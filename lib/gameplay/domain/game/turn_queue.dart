import 'dart:collection';
import 'dart:developer';

class TurnQueue {
  final Iterable<String> moverIds;

  TurnQueue(this.moverIds);

  String? get nextMoverId => moverIds.firstOrNull;

  TurnQueue nextQueue(Iterable<String> all) {
    String? next = nextMoverId;
    if (next == null) return TurnQueue([]);

    Iterable<String> nextMoverList = moverIds.skip(1);
    if (nextMoverList.isEmpty) {
      log("Queue Rolled Over to ${all.length}");
      List<String> newQueue = all.toList();
      newQueue.sort(); // this ensures No Double Moving!!!
      nextMoverList = newQueue;
    }

    return TurnQueue(nextMoverList);
  }
}
