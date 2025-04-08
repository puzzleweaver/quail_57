import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/emmy_type.dart';
import 'package:quail_57/select_bug/ui/bug_info_dialog.dart';
import 'package:quail_57/select_bug/ui/bug_pane.dart';

class BugSelectionButton extends StatelessWidget {
  final EmmyType type;

  const BugSelectionButton({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    onPressed() {
      // goTo(context, (context) => GameplayPage(initialBug: type), replace: true);
      showDialog(
        context: context,
        builder: (context) => BugInfoDialog(type: type),
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: BugPane(type: type, showName: true),
    );
  }
}
