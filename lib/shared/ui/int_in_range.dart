extension InRange on int {
  bool inRange(int? low, int? hi) =>
      (low == null || low <= this) && (hi == null || hi > this);
}

extension InPairRange on (int?, int?) {
  bool includes(int value) => value.inRange($1, $2);
}
