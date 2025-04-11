import 'package:quail_57/gameplay/domain/entity/bug.dart';
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
  Bug? get mover => fromTile.bug;
  Bug? get targetBug => toTile.bug;
  Fruit? get targetFruit => toTile.fruit;

  Map<Coordinate, Tile> _setFromAndTo(Tile newFromTile, Tile newToTile) {
    return {from: newFromTile, to: newToTile};
  }

  Map<Coordinate, Tile> get asMap {
    Bug? mover = this.mover;
    Bug? targetBug = this.targetBug;
    Fruit? targetFruit = this.targetFruit;

    // edge case
    if (mover == null) return {};

    // Handle bug collisions if they exist,
    if (targetBug != null) return bugMap(mover, targetBug);

    // else handle fruit collision,
    if (targetFruit != null) return fruitMap(mover, targetFruit);

    // else just move.
    return _setFromAndTo(fromTile.withBug(null), toTile.withBug(mover));
  }

  Map<Coordinate, Tile> bugMap(Bug mover, Bug target) {
    // Outcome outcome = mover.outcomeAgainst(target);
    // return switch(outcome) {
    //   case Outcome.ate => _setFromAndTo(),
    //   case Outcome.gotEaten => _setFromAndTo(),
    //   case Outcome.defend
    // };

    return {};
  }

  Map<Coordinate, Tile> fruitMap(Bug mover, Fruit target) {
    bool canEat = mover.bugType.canEatFruit(target.fruitType);
    if (canEat) {
      return _setFromAndTo(
        fromTile.withBug(null),
        toTile.withBug(mover.eatFruit(from, target)).withFruit(null),
      );
    }
    return _setFromAndTo(fromTile.withBug(null), toTile.withBug(mover));
  }
}
