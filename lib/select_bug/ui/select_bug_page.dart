import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/emmy_type.dart';
import 'package:quail_57/select_bug/ui/bug_selection_button.dart';
import 'package:quail_57/settings/ui/page_title.dart';
import 'package:quail_57/shared/ui/app_scaffold.dart';

class SelectBugPage extends StatelessWidget {
  const SelectBugPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: TitledPage(
            title: "Select Your Bug",
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "(also try tapping a locked bug!)",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  for (EmmyType type in EmmyType.all)
                    BugSelectionButton(type: type),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
