// trinary "primitive"
import 'dart:math';

enum Tri {
  low(false),
  mid(null),
  hi(true);

  final bool? state;
  const Tri(this.state);

  Tri? get less => switch (this) {
    low => null,
    mid => low,
    hi => mid,
  };

  Tri? get more => switch (this) {
    low => mid,
    mid => hi,
    hi => null,
  };

  static Tri get random {
    double choice = 3 * Random().nextDouble();
    if (choice < 1) return low;
    if (choice < 2) return mid;
    return hi;
  }

  static Iterable<Tri> get all => [low, mid, hi];

  @override
  String toString() => switch (this) {
    low => "<",
    mid => "o",
    hi => ">",
  };
}
