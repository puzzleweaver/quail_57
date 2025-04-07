import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/emmy.dart';
import 'package:quail_57/select_bug/ui/bug_selection_button.dart';
import 'package:quail_57/shared/ui/app_scaffold.dart';

class SelectBugPage extends StatelessWidget {
  const SelectBugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 5,
            runSpacing: 5,
            children: [
              for (EmmyType type in EmmyType.all)
                BugSelectionButton(type: type),
            ],
          ),
        ),
      ),
    );
  }
}
