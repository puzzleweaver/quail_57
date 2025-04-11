import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/geometry/bitri.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/turn.dart';
import 'package:quail_57/gameplay/ui/gameplay_renderer.dart';
import 'package:quail_57/gameplay/ui/viewport.dart';

class GameplayPainter extends CustomPainter {
  final Turn turn;
  final ZoomedViewport viewport;
  final Animation<double> animation;
  final bool isTall;
  final int idleValue;

  GameplayPainter({
    super.repaint,
    required this.turn,
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
    );

    // Rect screen = Rect.fromLTWH(0, 0, size.width, size.height);
    // canvas.drawRect(
    //   screen,
    //   Paint()
    //     ..color = Colors.black
    //     ..style = PaintingStyle.fill,
    // );

    Coordinate? root = turn.root;
    renderer.drawDepthOverlay(root.depth);

    void treeFrom(Coordinate? root) {
      renderer.drawTileRecursive(turn: turn, coordinate: root);
    }

    Coordinate? previousWhereYou = turn.you?.previousMove?.where;
    bool movedInto = turn.whereYou == previousWhereYou?.into;
    bool movedOutof = turn.whereYou == previousWhereYou?.outof;
    if (!animation.isCompleted) {
      if (movedInto) root = root.outof;
      if (movedOutof) root = root;
    }
    treeFrom(root);

    // offscreenMaybe
    if (isTall) {
      treeFrom(root.withOffset(BiTri.middle.up));
      treeFrom(root.withOffset(BiTri.middle.down));
    } else {
      treeFrom(root.withOffset(BiTri.middle.left));
      treeFrom(root.withOffset(BiTri.middle.right));
    }

    if (turn.you?.isInDanger == true) {
      if (idleValue == 1) renderer.drawOverlay(Colors.red.withAlpha(50));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
