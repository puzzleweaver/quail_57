import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:quail_57/gameplay/ui/gameplay_painter.dart';
import 'package:quail_57/gameplay/ui/viewport.dart';
import 'package:quail_57/math/coordinate.dart';
import 'package:quail_57/math/tree.dart';

class AnimatedGameWidget extends StatefulWidget {
  final Size size;
  final Tree tree;
  final void Function(Tree newTree) setTree;

  const AnimatedGameWidget({
    super.key,
    required this.size,
    required this.tree,
    required this.setTree,
  });

  @override
  State<StatefulWidget> createState() => AnimatedGameWidgetState();
}

class AnimatedGameWidgetState extends State<AnimatedGameWidget>
    implements TickerProvider {
  // widget variables
  Tree get tree => widget.tree;
  Size get size => widget.size;
  void Function(Tree) get setTree => widget.setTree;

  Tree fromTree = Tree.initial();
  ZoomedViewport fromViewport = ZoomedViewport.initial;
  ZoomedViewport get viewport =>
      fromViewport.lerpTo(viewportOf(tree), 1 - animation.value);
  ZoomedViewport viewportOf(Tree tree) {
    return ZoomedViewport(
      window: tree.root?.rect() ?? Rect.fromLTWH(0, 0, 1, 1),
    );
  }

  late Animation<double> animation;
  late AnimationController controller;
  bool get isAnimationDone => animation.value == 1;

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object's value.
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: GestureDetector(
        onTapUp: onTap,
        child: ClipRRect(
          child: CustomPaint(
            painter: GameplayPainter(
              fromTree: fromTree,
              tree: tree,
              viewport: viewport,
              animation: animation,
            ),
          ),
        ),
      ),
    );
  }

  void onTap(TapUpDetails tapDetails) {
    Offset tap = tapDetails.localPosition;
    double dim = MediaQuery.of(context).size.width;
    // Rect size = Rect.fromLTWH(0, 0, dim, dim);
    Rect unit = Rect.fromLTWH(0, 0, 1, 1);

    bool check(Coordinate? space) =>
        space
            ?.rect(unit: unit)
            .contains(viewport.inverseTransform(tap, Size(dim, dim))) ??
        false;

    Coordinate? current = tree.whereYou,
        left = current?.left,
        right = current?.right,
        up = current?.up,
        down = current?.down;
    if (current != null && check(current)) {
      if (current.isMiddle) return moveTo(current.outof);
      return moveTo(current.into);
    }
    if (check(left)) return moveTo(left);
    if (check(right)) return moveTo(right);
    if (check(down)) return moveTo(down);
    if (check(up)) return moveTo(up);
  }

  void moveTo(Coordinate? newYou) {
    if (newYou == null) return;
    Tree newTree = tree.moveYouTo(newYou);
    setState(() {
      fromViewport = viewport;
      fromTree = tree;
    });
    controller.reset();
    controller.forward();
    setTree(newTree);
  }
}
