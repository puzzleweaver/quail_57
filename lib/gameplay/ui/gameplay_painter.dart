import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/ui/gameplay_renderer.dart';
import 'package:quail_57/gameplay/ui/viewport.dart';
import 'package:quail_57/math/coordinate.dart';
import 'package:quail_57/math/tree.dart';

class GameplayPainter extends CustomPainter {
  final Tree fromTree;
  final Tree tree;
  final ZoomedViewport viewport;
  final Animation<double> animation;

  GameplayPainter({
    super.repaint,
    required this.tree,
    required this.viewport,
    required this.fromTree,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final renderer = GameplayRenderer(canvas, size, viewport);

    Rect screen = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(
      screen,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill,
    );

    renderer.drawTree(
      previousTree: fromTree,
      tree: tree,
      root: tree.root,
      maxDepth: 2,
      animationValue: animation.value,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
