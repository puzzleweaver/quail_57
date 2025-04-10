import 'dart:math';

extension DoubleRoll on double {
  // roll that sucker like a DICE
  bool get roll {
    return Random().nextDouble() < this;
  }
}
