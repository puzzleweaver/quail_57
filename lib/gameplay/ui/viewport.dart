import 'dart:ui';

class ZoomedViewport {
  // For now, just zoom in and make window fill the screen.
  final Rect window;
  // TODO avoid making window too small
  // final Coordinate root;

  ZoomedViewport({required this.window});

  static ZoomedViewport get initial =>
      ZoomedViewport(window: Rect.fromLTWH(0, 0, 1, 1));

  ZoomedViewport lerpTo(ZoomedViewport other, double t) {
    double s = 1 - t;
    return ZoomedViewport(
      window: Rect.fromLTRB(
        window.left * t + other.window.left * s,
        window.top * t + other.window.top * s,
        window.right * t + other.window.right * s,
        window.bottom * t + other.window.bottom * s,
      ),
    );
  }

  Rect transform(Rect rect, Size size) {
    return Rect.fromLTRB(
      transformX(rect.left, size),
      transformY(rect.top, size),
      transformX(rect.right, size),
      transformY(rect.bottom, size),
    );
  }

  double transformX(double x, Size size) {
    return (x - window.left) / window.width * size.width;
  }

  double transformY(double y, Size size) {
    return (y - window.top) / window.height * size.height;
  }

  double inverseX(double x, Size size) {
    return x / size.width * window.width + window.left;
  }

  double inverseY(double y, Size size) {
    return y / size.height * window.height + window.top;
  }

  Offset inverseTransform(Offset offset, Size size) {
    return Offset(inverseX(offset.dx, size), inverseY(offset.dy, size));
  }
}
