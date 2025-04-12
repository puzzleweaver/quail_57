import 'package:quail_57/gameplay/domain/entity/bug.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/entity/tile.dart';
import 'package:quail_57/gameplay/domain/game/tree.dart';

class MoveChanges {
  final Tree tree;
  final Coordinate from;
  final Coordinate to;

  MoveChanges({required this.tree, required this.from, required this.to});

  Tile get fromTile => tree[from];
  Tile get toTile => tree[to];
  Bug? get mover => fromTile.bug;
  Bug? get targetBug => toTile.bug;
  Fruit? get targetFruit => toTile.fruit;

  Map<Coordinate, Tile> get normalMove {
    return {
      from: fromTile.withBug(null),
      to: toTile.withBug(mover?.moved(from)),
    };
  }

  Map<Coordinate, Tile> get getDeltas {
    Bug? mover = this.mover;
    Bug? targetBug = this.targetBug;
    Fruit? targetFruit = this.targetFruit;

    // edge case
    if (mover == null) return {};

    // Handle bug collisions if they exist,
    if (targetBug != null) {
      return {
        from: fromTile.withBug(mover.attacked(to)),
        to: toTile.withBug(targetBug.defended(from, mover.type.attack)),
      };
    }

    // else handle fruit collision,
    if (targetFruit != null) {
      bool canEat = mover.type.canEatFruit(targetFruit.type);
      if (!canEat) return normalMove;
      return {
        from: fromTile.withBug(null),
        to: toTile.withFruit(null).withBug(mover.ateFruit(from, targetFruit)),
      };
    }

    // else just move.
    return normalMove;
  }
}
