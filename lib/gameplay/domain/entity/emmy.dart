import 'dart:math';

import 'package:quail_57/gameplay/domain/entity/emmy_type.dart';
import 'package:quail_57/gameplay/domain/entity/entity.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/move_type.dart';
import 'package:quail_57/shared/data/generate.dart';

class Emmy extends Entity {
  final EmmyType emmyType;
  final int health;
  final int belly;
  final MoveType? previousMove;
  @override
  final bool isYou;
  final int kills;

  int get attack => emmyType.attack;
  int get baseHealth => emmyType.health;
  int get hungriness => emmyType.hungriness;

  Emmy({
    required super.id,
    required super.type,
    required this.health,
    required this.belly,
    required this.emmyType,
    required this.previousMove,
    required this.isYou,
    required this.kills,
  });

  factory Emmy.create(
    EmmyType emmyType, {
    EntityType? type,
    String? id,
    bool? isYou,
  }) {
    return Emmy(
      id: id ?? Generate.id,
      type: type ?? EntityType.emmy,
      emmyType: emmyType,
      health: emmyType.health,
      belly: 100,
      previousMove: null,
      isYou: isYou ?? false,
      kills: 0,
    );
  }

  Emmy withEmmyType(EmmyType newEmmyType) {
    return Emmy.create(newEmmyType, type: type, id: id, isYou: isYou);
  }

  @override
  Emmy? get age {
    int newBelly = belly - emmyType.hungriness;
    if (newBelly < 0) return null;
    return withBelly(newBelly);
  }

  Emmy withBelly(int newBelly) {
    return Emmy(
      id: id,
      type: type,
      health: health,
      belly: newBelly,
      emmyType: emmyType,
      previousMove: previousMove,
      isYou: isYou,
      kills: kills,
    );
  }

  Emmy blocked(Coordinate to) => this;
  Emmy eatFruit(Coordinate from, Fruit fruit) =>
      withBelly(min(belly + 50, 100));

  bool get isInDanger {
    return belly < 20 || health < baseHealth / 4;
  }
}
