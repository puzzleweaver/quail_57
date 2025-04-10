import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/geometry/bitri.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/ui/gameplay_renderer.dart';
import 'package:quail_57/gameplay/ui/viewport.dart';
import 'package:quail_57/gameplay/domain/tree.dart';

class GameplayPainter extends CustomPainter {
  final Tree fromTree;
  final Tree tree;
  final ZoomedViewport viewport;
  final Animation<double> animation;
  final bool isTall;
  final int idleValue;

  GameplayPainter({
    super.repaint,
    required this.tree,
    required this.viewport,
    required this.fromTree,
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

    Coordinate? root = tree.root;
    renderer.drawDepthOverlay(root?.depth);

    void treeFrom(Coordinate? root) {
      renderer.drawTree(previousTree: fromTree, tree: tree, coordinate: root);
    }

    bool movedInto = tree.whereYou == fromTree.whereYou.into;
    bool movedOutof = tree.whereYou == fromTree.whereYou.outof;
    if (!animation.isCompleted) {
      if (movedInto) root = root?.outof;
      if (movedOutof) root = root;
    }
    treeFrom(root);

    // offscreenMaybe
    if (isTall) {
      treeFrom(root?.withOffset(BiTri.middle.up));
      treeFrom(root?.withOffset(BiTri.middle.down));
    } else {
      treeFrom(root?.withOffset(BiTri.middle.left));
      treeFrom(root?.withOffset(BiTri.middle.right));
    }

    if (tree.you?.isInDanger == true) {
      if (idleValue == 1) renderer.drawOverlay(Colors.red.withAlpha(50));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
