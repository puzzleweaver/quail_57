enum MoveType {
  none, // no change.
  blocked, // tries to move, but can't.
  normal, // moves without impediment.
  defend, // gets attacked by the target. / gets hurt
  attack, // attacks the target.
  eat, // eats the target.
  die, // gets eaten/keels over
}
