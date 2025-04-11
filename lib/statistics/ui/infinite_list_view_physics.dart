import 'package:flutter/material.dart';

class InfiniteListViewPhysics extends ScrollPhysics {
  final double itemWidth;

  const InfiniteListViewPhysics({required this.itemWidth, super.parent});

  @override
  InfiniteListViewPhysics applyTo(ScrollPhysics? ancestor) {
    return InfiniteListViewPhysics(
      itemWidth: itemWidth,
      parent: buildParent(ancestor),
    );
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // duration is proportional to velocity. Vaguely because...
    // faster thing take longer to stop moving? :shrug:
    double duration = velocity.abs() / itemWidth / 80;

    // target is offset from position by dx = v*dt
    double target = (position.pixels + duration * velocity);

    // round target to the nearest item (position=0 is centered on an item)
    target = (target / itemWidth).round() * itemWidth;

    return ScrollSpringSimulation(
      SpringDescription.withDurationAndBounce(
        // when dropped, take 300 millis; when flung, should feel natural
        duration: Duration(milliseconds: 300 + (1200 * duration).toInt()),

        // overdamped so no gross bouncing
        bounce: -0.0,
      ),
      position.pixels,
      target,
      velocity,
    );
  }

  @override
  bool get allowImplicitScrolling => false;
}
