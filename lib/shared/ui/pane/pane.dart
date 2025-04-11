import 'package:flutter/material.dart';
import 'package:quail_57/shared/ui/size_is_tall.dart';

class Pane extends StatelessWidget {
  final List<Widget> children;
  final int? perScreen;

  const Pane({super.key, required this.children, this.perScreen});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:
          children
              .map((child) => square(context: context, child: child))
              .toList(),
    );
  }

  static double dimensionOf(BuildContext context, {int? perScreen}) {
    perScreen ??= 3;
    return MediaQuery.of(context).size.lesser / (perScreen + 0.5);
  }

  Widget square({required BuildContext context, required Widget child}) {
    return SizedBox.square(
      dimension: dimensionOf(context, perScreen: perScreen),
      child: child,
    );
  }
}
