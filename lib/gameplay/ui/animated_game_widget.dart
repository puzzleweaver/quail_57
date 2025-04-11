import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/ui/gameplay_painter.dart';
import 'package:quail_57/gameplay/ui/viewport.dart';
import 'package:quail_57/gameplay/domain/tree.dart';
import 'package:quail_57/settings/domain/persisted.dart';
import 'package:quail_57/shared/ui/list_choice.dart';
import 'package:quail_57/shared/ui/size_is_tall.dart';

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

  Tree fromTree = Tree.initial(BugType.all.choice);
  ZoomedViewport fromViewport = ZoomedViewport.initial;
  ZoomedViewport viewportOf(Tree tree) {
    return fromViewport.lerpTo(rawViewportOf(tree), 1 - animation.value);
  }

  ZoomedViewport rawViewportOf(Tree tree) {
    return ZoomedViewport(
      window: tree.root?.rect() ?? Rect.fromLTWH(0, 0, 1, 1),
    );
  }

  late Timer timer;
  int idleValue = 0;

  late Animation<double> animation;
  late AnimationController controller;
  bool get isAnimationDone => animation.value == 1;

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);

  @override
  void initState() {
    super.initState();
    initAnimation();
    initIdleTimer();
    initViewport();
  }

  initViewport() {
    fromViewport = rawViewportOf(tree);
  }

  initAnimation() {
    controller = AnimationController(
      duration: Duration(milliseconds: PersistedInt.animationSpeed.value),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object's value.
        });
      });
  }

  initIdleTimer() {
    timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        idleValue = idleValue == 0 ? 1 : 0; // Toggle between 0 and 1
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: GestureDetector(
        onTapUp: onTap,
        child: CustomPaint(
          painter: GameplayPainter(
            fromTree: fromTree,
            tree: tree,
            viewport: viewportOf(tree),
            animation: animation,
            idleValue: idleValue,
            isTall: MediaQuery.of(context).size.isTall,
          ),
        ),
      ),
    );
  }

  void onTap(TapUpDetails tapDetails) {
    Offset tap = tapDetails.localPosition;
    double dim = MediaQuery.of(context).size.lesser;
    // Rect size = Rect.fromLTWH(0, 0, dim, dim);
    Rect unit = Rect.fromLTWH(0, 0, 1, 1);

    bool check(Coordinate? space) =>
        space
            ?.rect(unit: unit)
            .contains(viewportOf(tree).inverseTransform(tap, Size(dim, dim))) ??
        false;

    Coordinate? current = tree.whereYou;
    Iterable<Coordinate> adjacents =
        [
          current.right,
          current.up,
          current.left,
          current.down,
          current.left?.up,
          current.left?.down,
          current.right?.up,
          current.right?.down,
        ].whereType<Coordinate>();
    // if you tap the tile you're on, you go up or down
    if (check(current)) {
      if (tree[current].hasFloor) return moveTo(current.outof);
      return moveTo(current.into);
    }
    // if you tap an adjacent tile, you go there
    for (Coordinate coordinate in adjacents) {
      if (check(coordinate)) return moveTo(coordinate);
    }
  }

  void moveTo(Coordinate? newYou) {
    if (newYou == null) return;
    Tree newTree = tree.moveYouTo(newYou);

    // try to rebase!
    int? rebasableBy = newTree.rebasableBy;
    setState(() {
      fromTree = tree;
      if (rebasableBy != null) {
        newTree = newTree.rebase(rebasableBy);
        fromTree = fromTree.rebase(rebasableBy);
      }
      fromViewport = rawViewportOf(fromTree);
    });
    setTree(newTree);
    controller.reset();
    controller.forward();
  }
}
