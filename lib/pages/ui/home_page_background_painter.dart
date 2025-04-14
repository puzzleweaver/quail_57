import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/ui/gameplay_renderer.dart';
import 'package:quail_57/gameplay/ui/viewport.dart';
import 'package:quail_57/gameplay/domain/entity/tile.dart';
import 'package:quail_57/shared/ui/pair_addition.dart';
import 'package:quail_57/shared/ui/pair_first_second.dart';

class HomePageBackgroundPainter extends CustomPainter {
  final Tile Function((int, int)) getSpace;
  final Size screen;
  final Animation animation;

  HomePageBackgroundPainter({
    super.repaint,
    required this.getSpace,
    required this.screen,
    required this.animation,
  });

  double A = 8, B = 8;
  double xCurve(double t) => cos(t) - 2 * sin(A * t) / A;
  double yCurve(double t) => sin(t) + 2 * cos(B * t) / B;

  @override
  void paint(Canvas canvas, Size size) {
    GameplayRenderer renderer = GameplayRenderer(
      canvas: canvas,
      size: size,
      viewport: ZoomedViewport(
        window: Rect.fromLTWH(0, 0, size.width, size.height),
      ),
      idleValue: 0,
      animation: AlwaysStoppedAnimation(0),
      renderDepth: 0,
      center: Coordinate.zero,
    );

    double time = animation.value;
    double xCount = 30,
        yCount = (xCount * screen.height / screen.width).ceil().toDouble();
    double width = size.width / xCount;
    double xoff = xCurve(time) * 0.3 * xCount;
    double yoff = yCurve(time) * 15 - 15;
    (int, int) offset = (xoff, yoff).toInts();
    xoff -= offset.x;
    yoff -= offset.y;

    for (double i = -1; i <= xCount; i++) {
      for (double j = -1; j <= yCount + 1; j++) {
        //   for (double j = 0; j < count; j++) {
        Rect rect = Rect.fromLTWH(
          (i - xoff) * width,
          (j - yoff) * width,
          width,
          width,
        );
        renderer.drawImageRect(
          getSpace(offset + (i, j).toInts()).type.image,
          rect,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return this != oldDelegate;
  }
}
