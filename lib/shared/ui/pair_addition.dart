import 'package:quail_57/shared/ui/pair_first_second.dart';

extension PairAddition on (int, int) {
  (int, int) operator +((int, int) other) => (
    first + other.first,
    second + other.second,
  );
}

extension PairToInt on (double, double) {
  (int, int) toInts() => (first.toInt(), second.toInt());
}
