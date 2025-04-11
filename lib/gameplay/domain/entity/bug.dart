import 'dart:math';

import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/move_type.dart';
import 'package:quail_57/shared/data/generate.dart';

class Bug {
  final String id;
  final BugType bugType;
  final int health;
  final int belly;
  final MoveType? previousMove;
  final bool isYou;
  final int kills;

  int get attack => bugType.attack;
  int get baseHealth => bugType.health;
  int get hungriness => bugType.hungriness;

  Bug({
    required this.id,
    required this.health,
    required this.belly,
    required this.bugType,
    required this.previousMove,
    required this.isYou,
    required this.kills,
  });

  factory Bug.create(BugType bugType, {bool? isYou}) {
    return Bug(
      id: Generate.id,
      bugType: bugType,
      health: bugType.health,
      belly: 100,
      previousMove: null,
      isYou: isYou ?? false,
      kills: 0,
    );
  }

  Bug withBelly(int newBelly) {
    return Bug(
      id: id,
      health: health,
      belly: newBelly,
      bugType: bugType,
      previousMove: previousMove,
      isYou: isYou,
      kills: kills,
    );
  }

  Bug blocked(Coordinate to) => this;
  Bug eatFruit(Coordinate from, Fruit fruit) => withBelly(min(belly + 50, 100));

  bool get isInDanger {
    return belly < 20 || health < baseHealth / 4;
  }
}
