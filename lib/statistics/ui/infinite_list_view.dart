import 'package:flutter/material.dart';
import 'package:quail_57/statistics/ui/infinite_list_view_physics.dart';

class InfiniteListView extends StatelessWidget {
  final void Function(int) onIndex;
  final double height;
  final List<Widget> children;

  const InfiniteListView({
    super.key,
    required this.onIndex,
    required this.height,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          scrollies(context),
          IgnorePointer(child: gradients(context)),
        ],
      ),
    );
  }

  Widget gradients(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black,
            Colors.transparent,
            Colors.transparent,
            Colors.black,
          ],
        ),
      ),
    );
  }

  Widget scrollies(BuildContext context) {
    return RotatedBox(
      quarterTurns: -1,
      child: ListWheelScrollView.useDelegate(
        physics: InfiniteListViewPhysics(itemWidth: height),
        perspective: 0.00000001, // huh?
        itemExtent: height,
        onSelectedItemChanged: (index) => onIndex(index % children.length),
        childDelegate: ListWheelChildBuilderDelegate(
          builder:
              (context, index) => RotatedBox(
                quarterTurns: 1,
                child: children[index % children.length],
              ),
        ),
      ),
    );
  }
}
