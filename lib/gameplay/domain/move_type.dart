import 'dart:ui';

import 'package:quail_57/shared/ui/rect_lerp.dart';

enum MoveType {
  none, // no change.
  blocked, // tries to move, but can't.
  normal, // moves without impediment.
  defend, // gets attacked by the target. / gets hurt
  attack, // attacks the target.
  eat, // eats the target.
  die; // gets eaten/keels over

  Rect animatedBetween(Rect from, Rect to, double value) {
    return switch (this) {
      MoveType.none => from.lerpTo(to, value),
      MoveType.blocked => from.lerpTo(to, value),
      MoveType.normal => from.lerpTo(to, value),
      MoveType.defend => from.lerpTo(to, value),
      MoveType.attack => from.lerpTo(to, value),
      MoveType.eat => from.lerpTo(to, value),
      MoveType.die => from.lerpTo(to, value),
    };
  }
}
