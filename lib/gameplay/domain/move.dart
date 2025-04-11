import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/shared/ui/rect_animation.dart';

class Move {
  final Coordinate? where;
  final MoveType type;

  Move({required this.where, required this.type});

  Move rebase(int byDepth) {
    return Move(where: where?.rebase(byDepth), type: type);
  }

  static Move get none => Move(where: null, type: MoveType.none);
  static Move normal(Coordinate where) =>
      Move(where: where, type: MoveType.normal);
  static Move attack(Coordinate where) =>
      Move(where: where, type: MoveType.attack);
  static Move defend(Coordinate where) =>
      Move(where: where, type: MoveType.defend);
  static Move eat(Coordinate where) => Move(where: where, type: MoveType.eat);
  static Move die(Coordinate where) => Move(where: where, type: MoveType.die);
}

enum MoveType {
  none, // sit
  normal, // move
  defend, // gets attacked by the target. / gets hurt
  attack, // attacks the target.
  eat, // eats the target.
  die; // gets eaten/keels over

  RectAnimation get animation {
    return switch (this) {
      MoveType.none => RectAnimations.basic,
      MoveType.normal => RectAnimations.basic,
      MoveType.defend => RectAnimations.defend,
      MoveType.attack => RectAnimations.attack,
      MoveType.eat => RectAnimations.eat,
      MoveType.die => RectAnimations.die,
    };
  }
}
