import 'dart:ui';

extension RectLerp on Rect {
  double _lerp(double a, double b, double t) => a * (1 - t) + b * t;
  Rect lerpTo(Rect to, double t) {
    return Rect.fromLTRB(
      _lerp(left, to.left, t),
      _lerp(top, to.top, t),
      _lerp(right, to.right, t),
      _lerp(bottom, to.bottom, t),
    );
  }
}
