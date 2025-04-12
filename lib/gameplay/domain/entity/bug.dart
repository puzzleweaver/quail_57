import 'dart:math';

import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/game/move.dart';
import 'package:quail_57/shared/data/generate.dart';

class Bug {
  final String id;
  final BugType type;
  final int health;
  final int belly;
  final Move? previousMove;
  final bool isYou;
  final int kills;

  int get baseHealth => type.health;
  int get hungriness => type.hungriness;

  Bug({
    required this.id,
    required this.health,
    required this.belly,
    required this.type,
    required this.previousMove,
    required this.isYou,
    required this.kills,
  });

  factory Bug.create(BugType bugType, {bool? isYou}) {
    return Bug(
      id: Generate.id,
      type: bugType,
      health: bugType.health,
      belly: 100,
      previousMove: null,
      isYou: isYou ?? false,
      kills: 0,
    );
  }

  Bug rebase(int byDepth) {
    return withMove(previousMove?.rebase(byDepth) ?? Move.none);
  }

  Bug withBelly(int newBelly) {
    return Bug(
      id: id,
      health: health,
      belly: newBelly,
      type: type,
      previousMove: previousMove,
      isYou: isYou,
      kills: kills,
    );
  }

  Bug withHealth(int newHealth) {
    return Bug(
      id: id,
      health: newHealth,
      belly: belly,
      type: type,
      isYou: isYou,
      kills: kills,
      previousMove: previousMove,
    );
  }

  Bug withMove(Move previousMove) {
    return Bug(
      id: id,
      health: health,
      belly: belly,
      type: type,
      isYou: isYou,
      kills: kills,
      previousMove: previousMove,
    );
  }

  Bug ateFruit(Coordinate from, Fruit fruit) {
    return withBelly(min(belly + 50, 100)).withMove(Move.eat(from));
  }

  Bug moved(Coordinate from) {
    return withMove(Move.normal(from));
  }

  Bug attacked(Coordinate from) {
    return withMove(Move.attack(from));
  }

  Bug defended(Coordinate from, int attack) {
    return withMove(Move.defend(from)).withHealth(health - attack);
  }

  bool get isInDanger {
    return belly < 20 || health < baseHealth / 4;
  }
}
