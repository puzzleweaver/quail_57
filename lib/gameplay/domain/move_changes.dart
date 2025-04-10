import 'package:quail_57/gameplay/domain/entity/emmy.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/tile.dart';
import 'package:quail_57/gameplay/domain/tree.dart';

class MoveChanges {
  final Tree tree;
  final Coordinate from;
  final Coordinate to;

  MoveChanges(this.tree, this.from, this.to);

  Tile get fromTile => tree[from];
  Tile get toTile => tree[to];
  Emmy? get mover => fromTile.emmy;
  Emmy? get targetEmmy => toTile.emmy;
  Fruit? get targetFruit => toTile.fruit;

  Map<Coordinate, Tile> _setFromAndTo(Tile newFromTile, Tile newToTile) {
    return {from: newFromTile, to: newToTile};
  }

  Map<Coordinate, Tile> get asMap {
    Emmy? mover = this.mover;
    Emmy? targetEmmy = this.targetEmmy;
    Fruit? targetFruit = this.targetFruit;

    // edge case
    if (mover == null) return {};

    // Handle emmy collisions if they exist,
    if (targetEmmy != null) return emmyMap(mover, targetEmmy);

    // else handle fruit collision,
    if (targetFruit != null) return fruitMap(mover, targetFruit);

    // else just move.
    return _setFromAndTo(fromTile.withEmmy(null), toTile.withEmmy(mover));
  }

  Map<Coordinate, Tile> emmyMap(Emmy mover, Emmy target) {
    // Outcome outcome = mover.outcomeAgainst(target);
    // return switch(outcome) {
    //   case Outcome.ate => _setFromAndTo(),
    //   case Outcome.gotEaten => _setFromAndTo(),
    //   case Outcome.defend
    // };

    return {};
  }

  Map<Coordinate, Tile> fruitMap(Emmy mover, Fruit target) {
    bool canEat = mover.emmyType.canEatFruit(target.fruitType);
    if (canEat) {
      return _setFromAndTo(
        fromTile.withEmmy(null),
        toTile.withEmmy(mover.eatFruit(from, target)).withFruit(null),
      );
    }
    return _setFromAndTo(fromTile.withEmmy(null), toTile.withEmmy(mover));
  }
}
