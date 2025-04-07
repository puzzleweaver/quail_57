import 'dart:math';

import 'package:quail_57/gameplay/domain/move_type.dart';

abstract class Entity {
  final EntityType type;
  final String id;
  final MoveType? previousMove;

  static final int _idSize = 10000000;
  static String get _newId => (Random().nextInt(_idSize) + _idSize).toString();
  Entity({String? id, required this.type, this.previousMove})
    : id = id ?? _newId;

  // static Entity? get random {
  //   double choice = Random().nextDouble() * 2;
  //   if (choice < 1) return Emmy(emmyType: EmmyType.random);
  //   return Fruit.random;
  // }

  bool get isYou => type == EntityType.you;
  bool get isEmmy => type == EntityType.emmy;
  bool get isFruit => type == EntityType.fruit;
  bool get moves => isEmmy || isYou;
  bool get isOccupied => isEmmy || isYou || isFruit;

  @override
  String toString() => "$type ${id.substring(0, 8)}";
}

enum EntityType { you, emmy, fruit }
