// a coordinate that uniquely identifies a square on any level.
import 'dart:math';
import 'dart:ui';

import 'package:quail_57/math/bitri.dart';
import 'package:quail_57/math/tri.dart';

class Coordinate {
  final List<BiTri> sequence;
  Coordinate(this.sequence);

  int get depth => sequence.length;

  static Coordinate get zero => Coordinate([]);
  Coordinate get into => Coordinate([...sequence, BiTri.middle]);
  Coordinate? get outof => Coordinate(withoutLast);
  Coordinate? get left => replaceLast(last?.left);
  Coordinate? get down => replaceLast(last?.down);
  Coordinate? get up => replaceLast(last?.up);
  Coordinate? get right => replaceLast(last?.right);
  BiTri? get last => sequence.lastOrNull;
  Coordinate? replaceLast(BiTri? newLast) {
    if (newLast == null) return null;
    return Coordinate([...withoutLast, newLast]);
  }

  Coordinate get randomStep {
    List<Coordinate> dupe(int howMany, Coordinate? where) =>
        where == null ? [] : [for (int i = 0; i < howMany; i++) where];
    List<Coordinate> options =
        [
          ...dupe(1, into),
          ...dupe(1, outof),
          ...dupe(3, right),
          ...dupe(3, left),
          ...dupe(3, up),
          ...dupe(3, down),
        ].toList();
    if (options.isEmpty) return this;
    return options[Random().nextInt(options.length)];
  }

  List<BiTri> get withoutLast {
    if (sequence.isEmpty || sequence.length == 1) return [];
    return sequence.sublist(0, sequence.length - 1);
  }

  bool get isMiddle => last?.isMiddle ?? false;

  static Coordinate random(int minDepth, int maxDepth) {
    int actualDepth = minDepth + Random().nextInt(maxDepth - minDepth);
    return Coordinate([
      for (int i = 0; i < actualDepth; i++)
        BiTri.random(allowMiddle: i == actualDepth - 1),
    ]);
  }

  List<Coordinate> get next =>
      BiTri.all()
          .map((bt) => into?.replaceLast(bt))
          .whereType<Coordinate>()
          .toList();

  Rect rect({Rect unit = const Rect.fromLTWH(0, 0, 1, 1)}) {
    Rect narrow(BiTri bt, Rect bounds) {
      Tri xt = bt.a, yt = bt.b;
      return Rect.fromLTWH(
        switch (xt) {
          Tri.low => bounds.left,
          Tri.mid => bounds.left + bounds.width / 3,
          Tri.hi => bounds.left + 2 * bounds.width / 3,
        },
        switch (yt) {
          Tri.low => bounds.top,
          Tri.mid => bounds.top + bounds.height / 3,
          Tri.hi => bounds.top + 2 * bounds.height / 3,
        },
        bounds.width / 3,
        bounds.height / 3,
      );
    }

    Rect ret = unit;
    for (BiTri bt in sequence) {
      ret = narrow(bt, ret);
    }
    return ret;
  }

  @override
  String toString() => "(${sequence.join(" ")})";

  @override
  bool operator ==(Object other) {
    if (other is! Coordinate) return false;
    return [
      for (int i = 0; i < sequence.length; i++)
        sequence[i] == other.sequence.elementAtOrNull(i),
    ].every((cond) => cond);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hashAll(sequence);
}
