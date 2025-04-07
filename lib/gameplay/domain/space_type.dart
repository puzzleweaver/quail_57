import 'dart:ui' as ui;

import 'package:quail_57/shared/data/sprites.dart';

enum SpaceType {
  softwood1,
  softwood2,
  hardwood1,
  hardwood2,
  darkLeaf,
  lightLeaf,
  bark,
  dirt,
  goal;

  static List<SpaceType> get all => const [
    softwood1,
    softwood2,
    hardwood1,
    hardwood2,
    darkLeaf,
    lightLeaf,
    bark,
    dirt,
    goal,
  ];

  ui.Image? get mask {
    switch (this) {
      case hardwood1:
      case hardwood2:
      case goal:
        return Sprites.woodMask;
      case softwood1:
      case softwood2:
      case dirt:
      case bark:
      case darkLeaf:
        return Sprites.dirtMask;
      case lightLeaf:
        return Sprites.leafMask;
    }
  }

  ui.Image? get image {
    return switch (this) {
      hardwood1 => Sprites.woodBackground1,
      hardwood2 => Sprites.woodBackground2,
      softwood1 => Sprites.woodTile1,
      softwood2 => Sprites.woodTile2,
      dirt => Sprites.dirtTile,
      lightLeaf => Sprites.leafTile1,
      darkLeaf => Sprites.leafTile2,
      bark => Sprites.barkBackground,
      goal => Sprites.goalTile,
    };
  }
}
