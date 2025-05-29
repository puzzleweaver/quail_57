import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/game/game.dart';
import 'package:quail_57/gameplay/ui/gameplay_renderer.dart';
import 'package:quail_57/gameplay/ui/viewport.dart';

class GameplayPainter extends CustomPainter {
  final Game game;
  final ZoomedViewport viewport;
  final Animation<double> animation;
  final bool isTall;
  final int idleValue;

  GameplayPainter({
    super.repaint,
    required this.game,
    required this.viewport,
    required this.animation,
    required this.idleValue,
    required this.isTall,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final renderer = GameplayRenderer(
      canvas: canvas,
      size: size,
      viewport: viewport,
      renderDepth: 2,
      animation: animation,
      idleValue: idleValue,
      center: game.youCoordinate,
    );

    // Rect screen = Rect.fromLTWH(0, 0, size.width, size.height);
    // canvas.drawRect(
    //   screen,
    //   Paint()
    //     ..color = Colors.black
    //     ..style = PaintingStyle.fill,
    // );

    Coordinate? root = game.root;
    renderer.drawDepthOverlay(root.depth);

    void treeFrom(Coordinate? root) {
      renderer.drawTileRecursive(game: game, coordinate: root);
    }

    Coordinate? previousYouCoordinate = game.you?.previousMove?.coordinate;
    bool movedInto = game.youCoordinate == previousYouCoordinate?.into;
    bool movedOutof = game.youCoordinate == previousYouCoordinate?.outof;
    if (!animation.isCompleted) {
      if (movedInto) root = root.outof;
      if (movedOutof) root = root;
    }
    treeFrom(root);

    // if (game.you?.isInDanger == true) {
    //   if (idleValue == 1) renderer.drawOverlay(Colors.red.withAlpha(50));
    // }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
