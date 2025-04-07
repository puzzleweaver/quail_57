import 'dart:math';
import 'dart:ui';

extension OrientationUtilities on Size {
  bool get isTall => width < height;

  double get lesser => min(width, height);
  double get greater => max(width, height);
}
