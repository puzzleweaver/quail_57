import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/game/game.dart';
import 'package:quail_57/gameplay/ui/gameplay_painter.dart';
import 'package:quail_57/gameplay/ui/viewport.dart';
import 'package:quail_57/settings/domain/persisted.dart';
import 'package:quail_57/shared/ui/size_is_tall.dart';

class AnimatedGameWidget extends StatefulWidget {
  final Size size;
  final Game game;
  final void Function(Game newGame) setGame;

  const AnimatedGameWidget({
    super.key,
    required this.size,
    required this.game,
    required this.setGame,
  });

  @override
  State<StatefulWidget> createState() => AnimatedGameWidgetState();
}

class AnimatedGameWidgetState extends State<AnimatedGameWidget>
    implements TickerProvider {
  // widget variables
  Game get game => widget.game;
  Size get size => widget.size;

  ZoomedViewport fromViewport = ZoomedViewport.initial;
  ZoomedViewport viewportOf(Game game) {
    return fromViewport.lerpTo(rawViewportOf(game), 1 - animation.value);
  }

  ZoomedViewport rawViewportOf(Game game) {
    return ZoomedViewport(window: game.root.rect());
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
    fromViewport = rawViewportOf(game);
  }

  initAnimation() {
    controller = AnimationController(
      duration: Duration(milliseconds: PersistedInt.animationSpeed.value),
      vsync: this,
    );
    animation =
        Tween<double>(begin: 0, end: 1).animate(controller)
          ..addListener(() {
            if (mounted) setState(() {});
          })
          ..addStatusListener((status) {
            if (status.isCompleted) onAnimationComplete();
          });
  }

  void onAnimationComplete() {
    if (!game.isYourTurn) setGame(game.afterNextTurn());
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
            game: game,
            viewport: viewportOf(game),
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
            .contains(viewportOf(game).inverseTransform(tap, Size(dim, dim))) ??
        false;

    Coordinate current = game.youCoordinate;
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
      if (game.currentTree[current].hasFloor) return moveYou(current.outof);
      return moveYou(current.into);
    }
    // if you tap an adjacent tile, you go there
    for (Coordinate coordinate in adjacents) {
      if (check(coordinate)) return moveYou(coordinate);
    }
  }

  void moveYou(Coordinate? to) {
    if (to == null) return;
    setGame(game.afterYourNextTurn(to));
  }

  void setGame(Game newGame) {
    setState(() => fromViewport = rawViewportOf(game));
    widget.setGame(newGame);
    controller.reset();
    controller.forward();
  }
}
