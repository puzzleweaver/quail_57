import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quail_57/shared/data/assets.dart';

class Sprites {
  static List<ui.Image>? ant;
  static List<ui.Image>? antLarva;

  static List<ui.Image>? termite;
  static List<ui.Image>? termiteTD;

  static ui.Image? woodBackground2;
  static ui.Image? woodTile2;

  static ui.Image? testMask;

  static Future<ui.Image> _load(String asset) async {
    return rootBundle
        .load(asset)
        .then(
          (imageData) => decodeImageFromList(imageData.buffer.asUint8List()),
        );
  }

  static Future<List<ui.Image>> _loadAll(List<String> assets) async {
    return Future.wait(assets.map(_load));
  }

  static Future<void> init() {
    return Future.wait([
      _loadAll(Assets.ant).then((result) => ant = result),
      _loadAll(Assets.antLarva).then((result) => antLarva = result),
      _loadAll(Assets.termite).then((result) => termite = result),
      _loadAll(Assets.termiteTD).then((result) => termiteTD = result),
      _load(Assets.woodBackground2).then((result) => woodBackground2 = result),
      _load(Assets.woodTile2).then((result) => woodTile2 = result),
      _load(Assets.testMask).then((result) => testMask = result),
    ]);
  }
}
