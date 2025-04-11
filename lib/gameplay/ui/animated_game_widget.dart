import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/turn.dart';
import 'package:quail_57/gameplay/ui/gameplay_painter.dart';
import 'package:quail_57/gameplay/ui/viewport.dart';
import 'package:quail_57/settings/domain/persisted.dart';
import 'package:quail_57/shared/ui/size_is_tall.dart';

class AnimatedGameWidget extends StatefulWidget {
  final Size size;
  final Turn turn;
  final void Function(Turn newTurn) setTurn;

  const AnimatedGameWidget({
    super.key,
    required this.size,
    required this.turn,
    required this.setTurn,
  });

  @override
  State<StatefulWidget> createState() => AnimatedGameWidgetState();
}

class AnimatedGameWidgetState extends State<AnimatedGameWidget>
    implements TickerProvider {
  // widget variables
  Turn get turn => widget.turn;
  Size get size => widget.size;
  void Function(Turn) get setTurn => widget.setTurn;

  ZoomedViewport fromViewport = ZoomedViewport.initial;
  ZoomedViewport viewportOf(Turn turn) {
    return fromViewport.lerpTo(rawViewportOf(turn), 1 - animation.value);
  }

  ZoomedViewport rawViewportOf(Turn turn) {
    return ZoomedViewport(window: turn.root.rect());
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
    fromViewport = rawViewportOf(turn);
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
            turn: turn,
            viewport: viewportOf(turn),
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
            .contains(viewportOf(turn).inverseTransform(tap, Size(dim, dim))) ??
        false;

    Coordinate current = turn.whereYou;
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
      if (turn.currentTree[current].hasFloor) return moveTo(current.outof);
      return moveTo(current.into);
    }
    // if you tap an adjacent tile, you go there
    for (Coordinate coordinate in adjacents) {
      if (check(coordinate)) return moveTo(coordinate);
    }
  }

  void moveTo(Coordinate? newYou) {
    if (newYou == null) return;
    // TODO skip through everyone else's turns that are left?
    Turn newTurn = turn.afterYourNextTurn(newYou);

    // try to rebase!
    setState(() => fromViewport = rawViewportOf(turn));
    setTurn(newTurn);
    controller.reset();
    controller.forward();
  }
}
