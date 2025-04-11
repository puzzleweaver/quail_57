import 'dart:ui' as ui;

import 'package:quail_57/shared/data/sprites.dart';

class Fruit {
  final FruitType type;
  Fruit({required this.type});

  static Fruit get apple => Fruit(type: FruitType.apple);
  static Fruit get log => Fruit(type: FruitType.log);
}

enum FruitType {
  apple,
  log;

  static List<FruitType> get all => [apple, log];

  ui.Image? get image {
    return switch (this) {
      apple => Sprites.apple,
      log => Sprites.log,
    };
  }
}
