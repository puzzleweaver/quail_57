import 'package:flutter/material.dart';
import 'package:quail_57/shared/ui/pane/pane.dart';

class EmptyPane extends StatelessWidget {
  const EmptyPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Pane(children: [Container()]);
  }
}
