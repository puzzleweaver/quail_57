import 'dart:ui' as ui;

import 'package:quail_57/gameplay/domain/entity/entity.dart';
import 'package:quail_57/shared/data/sprites.dart';

class Fruit extends Entity {
  final FruitType fruitType;
  Fruit({required super.id, required this.fruitType})
    : super(type: EntityType.fruit);
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
