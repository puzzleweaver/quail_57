import 'dart:math';

import 'package:quail_57/gameplay/domain/entity/emmy_type.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/move_type.dart';
import 'package:quail_57/shared/data/generate.dart';

class Emmy {
  final String id;
  final EmmyType emmyType;
  final int health;
  final int belly;
  final MoveType? previousMove;
  final bool isYou;
  final int kills;

  int get attack => emmyType.attack;
  int get baseHealth => emmyType.health;
  int get hungriness => emmyType.hungriness;

  Emmy({
    required this.id,
    required this.health,
    required this.belly,
    required this.emmyType,
    required this.previousMove,
    required this.isYou,
    required this.kills,
  });

  factory Emmy.create(EmmyType emmyType, {bool? isYou}) {
    return Emmy(
      id: Generate.id,
      emmyType: emmyType,
      health: emmyType.health,
      belly: 100,
      previousMove: null,
      isYou: isYou ?? false,
      kills: 0,
    );
  }

  Emmy withBelly(int newBelly) {
    return Emmy(
      id: id,
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
