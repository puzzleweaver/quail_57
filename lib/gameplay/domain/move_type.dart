import 'package:quail_57/gameplay/domain/math/coordinate.dart';
import 'package:quail_57/gameplay/domain/entity/entity.dart';
import 'package:quail_57/gameplay/domain/space.dart';
import 'package:quail_57/gameplay/domain/tree.dart';

enum MoveType {
  none, // no change.
  blocked, // tries to move, but can't.
  normal, // moves without impediment.
  defend, // gets attacked by the target. / gets hurt
  attack, // attacks the target.
  eat, // eats the target.
  die; // gets eaten.

  Map<Coordinate, Space> changes(Tree tree, Coordinate from, Coordinate to) {
    Space fromSpace = tree[from];
    Space toSpace = tree[to];
    Entity? mover = fromSpace.entity;
    Entity? target = toSpace.entity;
    return switch (this) {
      none => {},
      normal => {
        from: fromSpace.withEntity(null),
        to: toSpace.withEntity(mover),
      },
      attack => {
        // TODO hurt you, heal them, etc idnno??
      },
      MoveType.blocked => throw UnimplementedError(),
      MoveType.defend => throw UnimplementedError(),
      MoveType.eat => throw UnimplementedError(),
      MoveType.die => throw UnimplementedError(),
    };
  }
}
