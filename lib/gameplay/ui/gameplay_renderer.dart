import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/geometry/bitri.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/move_type.dart';
import 'package:quail_57/gameplay/ui/viewport.dart';
import 'package:quail_57/gameplay/domain/entity/emmy.dart';
import 'package:quail_57/gameplay/domain/entity/entity.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/space.dart';
import 'package:quail_57/gameplay/domain/space_type.dart';
import 'package:quail_57/gameplay/domain/tree.dart';
import 'package:quail_57/shared/ui/rect_lerp.dart';

class GameplayRenderer {
  final Size size;
  final Canvas canvas;
  final ZoomedViewport viewport;
  final int renderDepth;
  final Animation animation;
  final int idleValue;

  GameplayRenderer({
    required this.canvas,
    required this.size,
    required this.viewport,
    required this.renderDepth,
    required this.animation,
    required this.idleValue,
  });

  void drawDepthOverlay(int? depth) {
    drawOverlay(_paneColor(depth ?? 0));
  }

  void drawOverlay(Color color) {
    canvas.drawRect(
      Rect.largest,
      Paint()
        ..style = PaintingStyle.fill
        ..color = color,
    );
  }

  void Function() drawTree({
    required Tree previousTree,
    required Tree tree,
    required Coordinate? root,
    int? depthLeft,
  }) {
    depthLeft ??= renderDepth;
    // if (initialCall) {
    //   drawSpace();
    // }
    if (root == null) return () {};
    if (depthLeft > 0) {
      List<void Function()> drawEntities = [];
      for (BiTri bt in BiTri.all(allowMiddle: true)) {
        bool isLeaf = tree[root].hasFloor || root.isMiddle == true;
        int nextDepth = isLeaf ? 0 : depthLeft - 1;
        Coordinate? nextRoot = root.into.replaceLast(bt);
        void Function() drawEntity = drawTree(
          previousTree: previousTree,
          tree: tree,
          root: nextRoot,
          depthLeft: nextDepth,
        );
        drawEntities.add(drawEntity);
      }
      drawEntities.map((f) => f()).toList();
    }

    drawSpace(root, tree[root], _rectFromCoord(root));
    return () => drawEntity(
      where: root,
      fromTree: previousTree,
      entity: tree[root].entity,
    );
  }

  void drawSpace(Coordinate where, Space space, Rect rect) {
    // draw floor

    drawShadowPane(rect, where.depth);
    drawFloor(rect, where.isMiddle || space.hasFloor, space.type);
  }

  void drawFloor(Rect rect, bool hole, SpaceType type) =>
      hole ? drawWall(rect, type) : drawFrame(rect, type);

  void drawWall(Rect rect, SpaceType type) => drawImageRect(type.image, rect);
  void drawFrame(Rect rect, SpaceType type) =>
      drawMaskedImage(type.image, type.mask, rect);
  void drawShadowPane(Rect rect, int depth) {
    // this will be the "usual" alpha value, when not fading in or out
    double middle = 75;

    // this is the "faded out in distance" alpha value. the brighter, the more exposed jank
    double far = 150;

    double ncq = _nearClipQuotient(rect);
    double fcq = _farClipQuotient(rect);
    int alpha = (middle * ncq + (far - middle) * fcq).toInt();
    canvas.drawRect(
      rect,
      Paint()
        ..style = PaintingStyle.fill
        ..color = _paneColor(depth).withAlpha(alpha),
    );
  }

  Color _paneColor(int depth) {
    Color sky = Colors.white;
    Color tree = Colors.black;
    return depth < 0 ? sky : tree;
    // Color lerp(double amt) =>
    //     Color.lerp(Colors.black, sky, amt) ?? Colors.black;
    // if (depth > 0) return Colors.black;
    // if (depth > -3) return lerp(0.5);
    // return sky;
  }

  void drawEntity({
    required Coordinate where,
    required Tree fromTree,
    required Entity? entity,
  }) {
    if (entity == null) return;
    Rect rect = _rectFromCoord(where);

    Entity? previousEntity = fromTree[where].entity;
    if (previousEntity?.isFruit == true && !animation.isCompleted) {
      drawFruit(previousEntity as Fruit, rect);
    }

    if (entity is Emmy) drawEmmy(entity, rect, fromTree);
    if (entity is Fruit) drawFruit(entity, rect);
  }

  void drawEmmy(Emmy emmy, Rect rect, Tree fromTree) {
    MoveType? moveType = emmy.previousMove;

    Rect toRect = rect;
    Coordinate? from = fromTree.findEntity(emmy);
    if (from != null) {
      Rect fromRect = _rectFromCoord(from);
      rect = fromRect.lerpTo(toRect, animation.value);
    }

    switch (moveType) {
      case MoveType.none:
      case null:
        drawImageRect(emmy.emmyType.frame(idleValue), rect);
      case MoveType.blocked:
        // TODO: Handle this case.
        throw UnimplementedError();
      case MoveType.normal:
        // TODO: Handle this case.
        throw UnimplementedError();
      case MoveType.defend:
        // TODO: Handle this case.
        throw UnimplementedError();
      case MoveType.attack:
        // TODO: Handle this case.
        throw UnimplementedError();
      case MoveType.eat:
        // TODO: Handle this case.
        throw UnimplementedError();
      case MoveType.die:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void drawFruit(Fruit fruit, Rect rect) {
    drawImageRect(fruit.fruitType.image, rect);
  }

  void drawImageRect(ui.Image? image, Rect rect) {
    if (image == null) {
      drawPlaceholder(rect);
      return;
    }

    canvas.drawImageRect(
      image,
      _rectFromImg(image),
      rect,
      _nearClipFadeout(rect),
    );
  }

  // ranges from 1 everywhere, to zero when things get too close
  double _nearClipQuotient(Rect rect) {
    double ratio = rect.width / size.width;
    double start = 1.5, end = 3.0;
    if (ratio < start) {
      return 1.0;
    } else if (ratio > end) {
      return 0.0;
    } else {
      return 1.0 - (ratio - start) / (end - start);
    }
  }

  // ranges from 0 everywhere, to 1 when things are too far away
  double _farClipQuotient(Rect rect) {
    double ratio = rect.width / size.width;
    num start = pow(1 / 3, renderDepth - 1), end = pow(1 / 3, renderDepth - 2);
    if (ratio < start) {
      return 1.0;
    } else if (ratio > end) {
      return 0.0;
    } else {
      return 1.0 - (ratio - start) / (end - start);
    }
  }

  Paint _nearClipFadeout(Rect rect) {
    int alpha = (255 * _nearClipQuotient(rect)).toInt();
    return Paint()..color = Color.fromARGB(alpha, 0, 0, 0);
  }

  drawMaskedImage(ui.Image? image, ui.Image? mask, Rect rect) {
    if (mask == null || image == null) {
      drawPlaceholder(rect);
      return;
    }
    Paint paint = _nearClipFadeout(rect);
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
