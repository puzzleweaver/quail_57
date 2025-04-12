import 'dart:collection';
import 'dart:developer';

class TurnQueue {
  final Iterable<String> queue;

  TurnQueue(this.queue);

  String? get nextMoverId => queue.firstOrNull;

  /// Get ([nextMoverId], [nextQueue]).
  ///
  /// [nextMoverId] is only null if [queue] ends up being empty.
  (String? nextMover, TurnQueue nextQueue) next(Iterable<String> all) {
    String? next = nextMoverId;
    if (next == null) return (null, TurnQueue([]));

    Iterable<String> nextQueue = queue.skip(1);
    if (nextQueue.isEmpty) {
      log("Queue Rolled Over to ${all.length}");
      List<String> newQueue = all.toList();
      newQueue.sort(); // this ensures No Double Moving!!!
      nextQueue = newQueue;
    }

    return (next, TurnQueue(nextQueue));
  }
}
