import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quail_57/shared/data/assets.dart';

class Sprites {
  static List<ui.Image>? ant;
  static List<ui.Image>? antTD;

  static List<ui.Image>? antLarva;
  static List<ui.Image>? antLarvaTD;

  static List<ui.Image>? antQueen;
  static List<ui.Image>? antQueenTD;

  static List<ui.Image>? grub;
  static List<ui.Image>? grubTD;

  static List<ui.Image>? wasp;
  static List<ui.Image>? waspTD;

  static List<ui.Image>? termite;
  static List<ui.Image>? termiteTD;

  static List<ui.Image>? bigTermite;
  static List<ui.Image>? bigTermiteTD;

  static ui.Image? woodBackground1;
  static ui.Image? woodBackground2;

  static ui.Image? woodTile1;
  static ui.Image? woodTile2;

  static ui.Image? barkBackground;
  static ui.Image? dirtTile;

  static ui.Image? leafTile1;
  static ui.Image? leafTile2;

  static ui.Image? dirtMask;
  static ui.Image? woodMask;
  static ui.Image? leafMask;

  static ui.Image? apple;
  static ui.Image? log;
  static ui.Image? goalTile;

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
      _loadAll(Assets.antTD).then((result) => antTD = result),

      _loadAll(Assets.antLarva).then((result) => antLarva = result),
      _loadAll(Assets.antLarvaTD).then((result) => antLarvaTD = result),

      _loadAll(Assets.antQueen).then((result) => antQueen = result),
      _loadAll(Assets.antQueenTD).then((result) => antQueenTD = result),

      _loadAll(Assets.termite).then((result) => termite = result),
      _loadAll(Assets.termiteTD).then((result) => termiteTD = result),

      _loadAll(Assets.bigTermite).then((result) => bigTermite = result),
      _loadAll(Assets.bigTermiteTD).then((result) => bigTermiteTD = result),

      _loadAll(Assets.grub).then((result) => grub = result),
      _loadAll(Assets.grubTD).then((result) => grubTD = result),

      _loadAll(Assets.wasp).then((result) => wasp = result),
      _loadAll(Assets.waspTD).then((result) => waspTD = result),

      _load(Assets.woodBackground1).then((result) => woodBackground1 = result),
      _load(Assets.woodBackground2).then((result) => woodBackground2 = result),

      _load(Assets.woodTile1).then((result) => woodTile1 = result),
      _load(Assets.woodTile2).then((result) => woodTile2 = result),

      _load(Assets.dirtMask).then((result) => dirtMask = result),
      _load(Assets.woodMask).then((result) => woodMask = result),
      _load(Assets.leafMask).then((result) => leafMask = result),

      _load(Assets.dirtTile).then((result) => dirtTile = result),
      _load(Assets.barkBackground).then((result) => barkBackground = result),

      _load(Assets.leafTile1).then((result) => leafTile1 = result),
      _load(Assets.leafTile2).then((result) => leafTile2 = result),

      _load(Assets.fruit).then((result) => apple = result),
      _load(Assets.log).then((result) => log = result),
      _load(Assets.goal).then((result) => goalTile = result),
    ]);
  }
}
