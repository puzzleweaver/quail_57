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

  static List<Tri>? carry(List<Tri>? list, Tri offset) {
    if (list == null) return null;
    if (offset == mid) return list;
    if (list.isEmpty) return [];

    if (offset == low) {
      Tri? less = list.last.less;
      if (less != null) {
        list.last = less;
        return list;
      } else {
        List<Tri>? wl = carry(withoutLast(list), low);
        if (wl == null) return null;
        return [...wl, hi];
      }
    }

    if (offset == hi) {
      Tri? more = list.last.more;
      if (more != null) {
        list.last = more;
        return [...list];
      } else {
        List<Tri>? wl = carry(withoutLast(list), hi);
        if (wl == null) return null;
        return [...wl, low];
      }
    }

    return null;
  }

  @override
  String toString() => switch (this) {
    low => "-",
    mid => "o",
    hi => "+",
  };
}

List<T>? withoutLast<T>(List<T> list) {
  if (list.isEmpty) return null;
  return [for (int i = 0; i < list.length - 1; i++) list[i]];
}
