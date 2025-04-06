import 'package:quail_57/math/tri.dart';

/// 2d trinary variable, uniquely identifies a set of 9 subsquares
class BiTri {
  final Tri a, b;
  BiTri(this.a, this.b);

  static BiTri get middle => BiTri(Tri.mid, Tri.mid);
  static BiTri? nullable(Tri? a, Tri? b) {
    if (a == null || b == null) return null;
    return BiTri(a, b);
  }

  BiTri? get left => BiTri.nullable(a.less, b);
  BiTri? get right => BiTri.nullable(a.more, b);
  BiTri? get up => BiTri.nullable(a, b.less);
  BiTri? get down => BiTri.nullable(a, b.more);

  bool get isMiddle => a == Tri.mid && b == Tri.mid;

  @override
  toString() => "$a$b";

  @override
  bool operator ==(Object other) {
    if (other is! BiTri) return false;
    return other.a == a && other.b == b;
  }

  static Iterable<BiTri> all({bool allowMiddle = false}) {
    Iterable<BiTri> ret = Tri.all.expand(
      (a) => Tri.all.map((b) => BiTri(a, b)),
    );
    return allowMiddle ? ret : ret.where((bt) => !bt.isMiddle);
  }

  static BiTri random({bool allowMiddle = false}) {
    BiTri ret = BiTri(Tri.random, Tri.random);
    if (ret.isMiddle) return random(allowMiddle: allowMiddle);
    return ret;
  }

  @override
  int get hashCode => Object.hash(a, b);
}
