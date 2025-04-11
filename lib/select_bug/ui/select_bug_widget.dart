import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/emmy_type.dart';
import 'package:quail_57/select_bug/ui/bug_pane.dart';
import 'package:quail_57/shared/ui/pane/pane.dart';
import 'package:quail_57/shared/ui/pane/pane_button.dart';
import 'package:quail_57/statistics/ui/infinite_list_view.dart';

class SelectBugWidget extends StatefulWidget {
  final EmmyType type;
  final List<EmmyType> allTypes;
  final void Function(EmmyType newType) setType;

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
  List<EmmyType> get allTypes => widget.allTypes;
  EmmyType get type => widget.type;
  void Function(EmmyType) get setType => widget.setType;

  double speed = 0;

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    double dimension = Pane.dimensionOf(context, perScreen: 3);
    return InfiniteListView(
      onIndex: (index) => setType(allTypes[index]),
      height: dimension,
      children: [
        for (EmmyType bugType in allTypes)
          PaneButton(
            onPressed: () {},
            child: BugPane(type: bugType, perScreen: 3),
          ),
      ],
    );
  }
}
