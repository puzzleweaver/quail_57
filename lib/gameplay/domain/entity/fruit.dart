import 'dart:ui' as ui;

import 'package:quail_57/shared/data/sprites.dart';

class Fruit {
  final FruitType fruitType;
  Fruit({required this.fruitType});

  static Fruit get apple => Fruit(fruitType: FruitType.apple);
  static Fruit get log => Fruit(fruitType: FruitType.log);
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
