import 'dart:math';
import 'dart:ui';

import 'package:quail_57/shared/ui/rect_lerp.dart';

class RectAnimationArgs {
  final Rect from, to;
  final double value;

  RectAnimationArgs(this.from, this.to, this.value);
}

class RectAnimation {
  final Rect Function(RectAnimationArgs args) animate;

  RectAnimation(this.animate);

  RectAnimation curry(double Function(double) f) {
    return RectAnimation(
      (args) => animate(RectAnimationArgs(args.from, args.to, f(args.value))),
    );
  }

  RectAnimation get reverse {
    return RectAnimation(
      (args) => animate(RectAnimationArgs(args.to, args.from, args.value)),
    );
  }
}

class RectAnimations {
  static double _turnn(double x) => _turn((1 - x) * (1 - x));
  static double _turn(double x) => 4 * x * (1 - x);
  static double _shake(double x) => sin(3.0 * 2.0 * pi * x) * 0.2;
  static double _boink(double x) {
    if (x < 0.5) return 2 * x;
    return 1 - (sin(4.0 * pi * x).abs() * 0.2);
  }

  static RectAnimation get basic =>
      RectAnimation((args) => args.from.lerpTo(args.to, args.value));
  static RectAnimation get attack => basic.reverse.curry(_turnn);
  static RectAnimation get defend => basic.reverse.curry(_shake);
  static RectAnimation get eat => basic.curry(_boink);
  static RectAnimation get die => basic.curry(_shake);
}
