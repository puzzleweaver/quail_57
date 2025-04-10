// a coordinate that uniquely identifies a square on any level.
import 'dart:ui';

import 'package:quail_57/gameplay/domain/geometry/bitri.dart';
import 'package:quail_57/gameplay/domain/geometry/tri.dart';

class Coordinate {
  final List<BiTri> sequence;
  final int depthOffset;
  Coordinate(this.sequence, this.depthOffset);

  int get length => sequence.length;
  int get depth => depthOffset + length;

  static Coordinate get zero => Coordinate([], 0);
  Coordinate get into => Coordinate([...sequence, BiTri.middle], depthOffset);
  Coordinate get outof => Coordinate(withoutLast, depthOffset);
  Coordinate? get left => replaceLast(last?.left);
  Coordinate? get down => replaceLast(last?.down);
  Coordinate? get up => replaceLast(last?.up);
  Coordinate? get right => replaceLast(last?.right);
  BiTri? get last => sequence.lastOrNull;
  Coordinate? replaceLast(BiTri? newLast) {
    if (newLast == null) return null;
    return Coordinate([...withoutLast, newLast], depthOffset);
  }

  Coordinate? rebase(int byDepth) {
    if (byDepth == 0) return this;
    BiTri makeUpCoordinate(int i) => switch (i % 4) {
      0 => BiTri(Tri.mid, Tri.low),
      1 => BiTri(Tri.low, Tri.mid),
      2 => BiTri(Tri.mid, Tri.hi),
      _ => BiTri(Tri.hi, Tri.mid),
    };

    return Coordinate([
      for (int i = byDepth; i < length; i++)
        if (i >= 0 && i < length) sequence[i] else makeUpCoordinate(i),
    ], depthOffset + byDepth);
  }

  Coordinate? withOffset(BiTri? offset) {
    if (offset == null) return this;
    List<Tri> as = sequence.map((bt) => bt.a).toList();
    List<Tri> bs = sequence.map((bt) => bt.b).toList();
    List<Tri>? nas = Tri.carry(as, offset.a);
    List<Tri>? nbs = Tri.carry(bs, offset.b);
    if (nas == null || nbs == null) return null;
    return Coordinate([
      for (int i = 0; i < nas.length; i++) BiTri(nas[i], nbs[i]),
    ], depthOffset);
  }

  List<BiTri> get withoutLast {
    if (sequence.isEmpty || sequence.length == 1) return [];
    return sequence.sublist(0, sequence.length - 1);
  }

  List<Coordinate> get next =>
      BiTri.all()
          .map((bt) => into.replaceLast(bt))
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

  Iterable<Coordinate> get adjacents {
    return [
      up,
      left,
      right,
      down,
      up?.left,
      up?.right,
      down?.left,
      down?.right,
      // TODO does this include into/outof? for now no.
    ].whereType<Coordinate>();
  }

  @override
  String toString() => "(${sequence.join(" ")})";

  @override
  bool operator ==(Object other) {
    if (other is! Coordinate) return false;
    if (sequence.length != other.sequence.length) return false;
    return [
      for (int i = 0; i < sequence.length; i++)
        sequence[i] == other.sequence.elementAtOrNull(i),
    ].every((cond) => cond);
  }

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hashAll(sequence);
}
