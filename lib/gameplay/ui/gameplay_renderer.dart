import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/ui/viewport.dart';
import 'package:quail_57/math/bitri.dart';
import 'package:quail_57/math/coordinate.dart';
import 'package:quail_57/math/entity.dart';
import 'package:quail_57/math/space.dart';
import 'package:quail_57/math/tree.dart';
import 'package:quail_57/shared/data/sprites.dart';
import 'package:quail_57/shared/ui/rect_lerp.dart';

class GameplayRenderer {
  final Size size;
  final Canvas canvas;
  final ZoomedViewport viewport;

  ui.Image? bgImg = Sprites.woodTile2;

  GameplayRenderer(this.canvas, this.size, this.viewport);

  void drawTree({
    required Tree previousTree,
    required Tree tree,
    required Coordinate? root,
    required int maxDepth,
    required double animationValue,
  }) {
    if (root == null) return;
    if (maxDepth > 0) {
      for (BiTri bt in BiTri.all(allowMiddle: true)) {
        bool isLeaf = tree[root].hasFloor || root.isMiddle == true;
        int nextDepth = isLeaf ? 0 : maxDepth - 1;
        Coordinate? nextRoot = root.into.replaceLast(bt);
        // if (nextRoot != null) {
        //   drawSpace(nextRoot, tree[nextRoot], _rectFromCoord(nextRoot));
        //   drawEntity(
        //     where: nextRoot,
        //     previousTree: previousTree,
        //     entity: tree[nextRoot].entity,
        //     animationValue: animationValue,
        //   );
        // }
        drawTree(
          previousTree: previousTree,
          tree: tree,
          root: nextRoot,
          maxDepth: nextDepth,
          animationValue: animationValue,
        );
      }
    }

    drawSpace(root, tree[root], _rectFromCoord(root));
    drawEntity(
      where: root,
      previousTree: previousTree,
      entity: tree[root].entity,
      animationValue: animationValue,
    );
  }

  void drawSpace(Coordinate where, Space space, Rect rect) {
    // draw floor

    canvas.drawRect(
      rect,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.black.withAlpha(100),
    );
    drawFloor(rect, where.isMiddle || space.hasFloor);
  }

  void drawFloor(Rect rect, bool hole) =>
      hole ? drawWall(rect) : drawFrame(rect);
  void drawWall(Rect rect) => drawImageRect(bgImg, rect);
  void drawFrame(Rect rect) => drawMaskedImage(bgImg, Sprites.testMask, rect);

  void drawEntity({
    required Coordinate where,
    required Tree previousTree,
    required Entity? entity,
    required double animationValue,
  }) {
    if (entity == null) return;

    Rect rect = _rectFromCoord(where);
    if (entity.moves) {
      Rect toRect = rect;
      Coordinate? fromRoot = previousTree.findEntity(entity);
      if (fromRoot != null) {
        Rect fromRect = _rectFromCoord(fromRoot);
        rect = fromRect.lerpTo(toRect, animationValue);
      }
    }

    // draw contents
    switch (entity.type) {
      case Entities.you:
        drawYou(rect);
      case Entities.emmy:
        drawEmmy(rect);
      case Entities.fruit:
        drawFruit(rect);
      default:
        drawPlaceholder(rect);
    }
  }

  void drawYou(Rect rect) {
    drawImageRect(
      Sprites.termite?[Random().nextInt(Sprites.termite?.length ?? 1)],
      rect,
    );
  }

  void drawEmmy(Rect rect) {
    drawImageRect(
      Sprites.ant?[Random().nextInt(Sprites.termite?.length ?? 1)],
      rect,
    );
  }

  void drawFruit(Rect rect) {
    drawImageRect(
      Sprites.antLarva?[Random().nextInt(Sprites.termite?.length ?? 1)],
      rect,
    );
  }

  Paint fillPaint(Entity? entity) =>
      Paint()
        ..style = PaintingStyle.fill
        ..color = colorOf(entity) ?? Colors.transparent;
  // colorOf(contents)?.withAlpha(50) ?? Colors.transparent;

  Paint get strokePaint =>
      Paint()
        ..style = PaintingStyle.stroke
        ..color = Colors.black;

  Color? colorOf(Entity? entity) {
    if (entity == Entity.emmy) return Colors.purple;
    if (entity == Entity.fruit) return Colors.pink;
    return Colors.blue;
  }

  void drawImageRect(ui.Image? image, Rect rect) {
    if (image == null) {
      drawPlaceholder(rect);
      return;
    }

    canvas.drawImageRect(image, _rectFromImg(image), rect, Paint());
  }

  drawMaskedImage(ui.Image? image, ui.Image? mask, Rect rect) {
    if (mask == null || image == null) {
      drawPlaceholder(rect);
      return;
    }
    Paint paint = Paint();
    canvas.saveLayer(rect, paint);
    canvas.drawImageRect(mask, _rectFromImg(mask), rect, paint);
    canvas.drawImageRect(
      image,
      _rectFromImg(image),
      rect,
      paint..blendMode = BlendMode.srcIn,
    );
    canvas.restore();
  }

  drawPlaceholder(Rect rect) {
    canvas.drawRect(
      rect,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.red,
    );
  }

  Rect _rectFromImg(ui.Image image) =>
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());

  Rect _rectFromCoord(Coordinate coordinate) => viewport.transform(
    coordinate.rect(unit: Rect.fromLTWH(0, 0, 1, 1)),
    size,
  );
}
