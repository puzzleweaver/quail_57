import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/geometry/bitri.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/move.dart';
import 'package:quail_57/gameplay/domain/tile.dart';
import 'package:quail_57/gameplay/domain/turn.dart';
import 'package:quail_57/gameplay/ui/viewport.dart';
import 'package:quail_57/gameplay/domain/entity/bug.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/tile_type.dart';
import 'package:quail_57/shared/ui/rect_animation.dart';

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

  TileRenderer drawTileRecursive({
    required Turn turn,
    required Coordinate? coordinate,
    int? depthLeft,
    bool first = true,
  }) {
    depthLeft ??= renderDepth;
    // if (initialCall) {
    //   drawSpace();
    // }
    if (coordinate == null) return TileRenderer();

    Tile tile = turn.currentTree[coordinate];
    if (depthLeft > 0) {
      List<TileRenderer> tilesToRender = [];
      for (BiTri bt in BiTri.all(allowMiddle: true)) {
        bool isLeaf = tile.hasFloor == true;
        int nextDepth = isLeaf ? 0 : depthLeft - 1;
        Coordinate? nextCoordinate = coordinate.into.replaceLast(bt);
        tilesToRender.add(
          drawTileRecursive(
            turn: turn,
            coordinate: nextCoordinate,
            depthLeft: nextDepth,
            first: false,
          ),
        );
      }
      tilesToRender.shuffle();
      for (var ttr in tilesToRender) {
        ttr.drawTile?.call();
      }
      for (var ttr in tilesToRender) {
        ttr.drawFruit?.call();
      }
      for (var ttr in tilesToRender) {
        ttr.drawBug?.call();
      }
    }

    Rect rect = _rectFromCoord(coordinate);

    TileRenderer ret = TileRenderer(
      drawBug: () => drawBug(tile.bug, rect, turn),
      drawFruit: () => drawFruit(tile.fruit, rect),
      drawTile: () => drawTile(turn, coordinate, rect),
    );
    if (first) ret.drawAll();
    return ret;
  }

  void drawTile(Turn turn, Coordinate where, Rect rect) {
    if (turn.whereYou == where) drawRect(rect);

    // shadow (on the things underneath)
    drawShadowPane(rect, where.depth);

    // floor
    Tile tile = turn.currentTree[where];
    drawFloor(rect, tile.hasFloor, tile.type);
  }

  void drawFloor(Rect rect, bool hole, TileType type) =>
      hole ? drawWall(rect, type) : drawFrame(rect, type);

  void drawWall(Rect rect, TileType type) => drawImageRect(type.image, rect);
  void drawFrame(Rect rect, TileType type) =>
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

  void drawRect(Rect rect) {
    canvas.drawRect(
      rect,
      Paint()
        ..color = Colors.red
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke,
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

  void drawBug(Bug? bug, Rect rect, Turn turn) {
    if (bug == null) return;
    Move? move = bug.previousMove;

    Rect toRect = rect;
    Coordinate? from = move?.where;
    if (from != null) {
      Rect fromRect = _rectFromCoord(from);
      rect = (move?.type.animation ?? bug.type.animation).animate(
        RectAnimationArgs(fromRect, toRect, animation.value),
      );
    }

    drawImageRect(bug.type.frame(idleValue), rect);
  }

  void drawFruit(Fruit? fruit, Rect rect) {
    if (fruit == null) return;
    drawImageRect(fruit.type.image, rect);
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

class TileRenderer {
  final void Function()? drawFruit;
  final void Function()? drawBug;
  final void Function()? drawTile;

  TileRenderer({this.drawFruit, this.drawBug, this.drawTile});

  void drawAll() {
    drawTile?.call();
    drawFruit?.call();
    drawBug?.call();
  }
}
