import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/select_bug/ui/bug_pane.dart';
import 'package:quail_57/shared/ui/pane/pane.dart';
import 'package:quail_57/shared/ui/pane/pane_button.dart';
import 'package:quail_57/statistics/ui/infinite_list_view.dart';

class SelectBugWidget extends StatefulWidget {
  final BugType type;
  final List<BugType> allTypes;
  final void Function(BugType newType) setType;

  const SelectBugWidget({
    super.key,
    required this.type,
    required this.allTypes,
    required this.setType,
  });

  @override
  State<StatefulWidget> createState() => SelectBugWidgetState();
}

class SelectBugWidgetState extends State<SelectBugWidget> {
  List<BugType> get allTypes => widget.allTypes;
  BugType get type => widget.type;
  void Function(BugType) get setType => widget.setType;

  double speed = 0;

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    double dimension = Pane.dimensionOf(context, perScreen: 3);
    return InfiniteListView(
      onIndex: (index) => setType(allTypes[index]),
      height: dimension,
      children: [
        for (BugType bugType in allTypes)
          PaneButton(
            onPressed: () {},
            child: BugPane(type: bugType, perScreen: 3),
          ),
      ],
    );
  }
}
