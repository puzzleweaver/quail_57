import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/shared/ui/rect_animation.dart';

class Move {
  final Coordinate? coordinate;
  final MoveType type;

  Move({required this.coordinate, required this.type});

  Move rebase(int byDepth) {
    return Move(coordinate: coordinate?.rebase(byDepth), type: type);
  }

  static Move get none => Move(coordinate: null, type: MoveType.none);
  static Move normal(Coordinate coordinate) =>
      Move(coordinate: coordinate, type: MoveType.normal);
  static Move attack(Coordinate coordinate) =>
      Move(coordinate: coordinate, type: MoveType.attack);
  static Move defend(Coordinate coordinate) =>
      Move(coordinate: coordinate, type: MoveType.defend);
  static Move eat(Coordinate coordinate) =>
      Move(coordinate: coordinate, type: MoveType.eat);
  static Move die(Coordinate coordinate) =>
      Move(coordinate: coordinate, type: MoveType.die);
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
