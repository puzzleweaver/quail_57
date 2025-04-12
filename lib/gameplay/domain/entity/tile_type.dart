import 'dart:ui' as ui;

import 'package:quail_57/shared/data/sprites.dart';

enum TileType {
  softwood1,
  softwood2,
  hardwood1,
  hardwood2,
  darkLeaf,
  lightLeaf,
  bark,
  dirt,
  goal;

  static List<TileType> get all => const [
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
      goal => Sprites.goal,
    };
  }

  double get appleChance {
    return switch (this) {
      TileType.softwood1 => 0.1,
      TileType.softwood2 => 0.15,
      TileType.hardwood1 => 0.01,
      TileType.hardwood2 => 0.01,
      TileType.darkLeaf => 0.3,
      TileType.lightLeaf => 0.25,
      TileType.bark => 0.0,
      TileType.dirt => 0.0,
      TileType.goal => 0.0,
    };
  }

  double get logChance {
    return switch (this) {
      TileType.softwood1 => 0.2,
      TileType.softwood2 => 0.2,
      TileType.hardwood1 => 0.3,
      TileType.hardwood2 => 0.3,
      TileType.darkLeaf => 0.05,
      TileType.lightLeaf => 0.0,
      TileType.bark => 0.1,
      TileType.dirt => 0.1,
      TileType.goal => 0.0,
    };
  }
}
