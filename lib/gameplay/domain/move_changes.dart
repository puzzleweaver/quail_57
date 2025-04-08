import 'package:quail_57/gameplay/domain/entity/emmy.dart';
import 'package:quail_57/gameplay/domain/entity/entity.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/space.dart';
import 'package:quail_57/gameplay/domain/tree.dart';

class MoveChanges {
  final Tree tree;
  final Coordinate from;
  final Coordinate to;

  MoveChanges(this.tree, this.from, this.to);

  Space get fromSpace => tree[from];
  Space get toSpace => tree[to];
  Entity? get mover => fromSpace.entity?.age;
  Entity? get target => toSpace.entity;

  Map<Coordinate, Space> _setFromAndTo(Entity? newFrom, Entity? newTo) {
    return {from: fromSpace.withEntity(newFrom), to: toSpace.withEntity(newTo)};
  }

  Map<Coordinate, Space> get asMap {
    Entity? mover = this.mover;
    if (mover is! Emmy) return {};
    // so mover is an emmy now.

    Entity? target = this.target;
    switch (target) {
      case null:
        return _setFromAndTo(null, mover);
      case Emmy targetEmmy:
        return emmyMap(mover, targetEmmy);
      case Fruit targetFruit:
        return fruitMap(mover, targetFruit);
      case _:
        throw UnimplementedError("Missed Something?");
    }
  }

  Map<Coordinate, Space> emmyMap(Emmy mover, Emmy target) {
    // Outcome outcome = mover.outcomeAgainst(target);
    // return switch(outcome) {
    //   case Outcome.ate => _setFromAndTo(),
    //   case Outcome.gotEaten => _setFromAndTo(),
    //   case Outcome.defend
    // };

    return {};
  }

  Map<Coordinate, Space> fruitMap(Emmy mover, Fruit target) {
    bool canEat = mover.emmyType.canEatFruit(target.fruitType);
    if (canEat) return _setFromAndTo(null, mover.eatFruit(from, target));
    return _setFromAndTo(mover.blocked(to), target);
  }
}
