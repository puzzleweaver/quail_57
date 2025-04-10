import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/emmy_type.dart';
import 'package:quail_57/gameplay/ui/gameplay_page.dart';
import 'package:quail_57/select_bug/ui/bug_pane.dart';
import 'package:quail_57/settings/domain/persisted.dart';
import 'package:quail_57/shared/ui/go_to.dart';
import 'package:quail_57/shared/ui/pair_first_second.dart';

class BugInfoDialog extends StatelessWidget {
  final EmmyType type;

  const BugInfoDialog({super.key, required this.type});

  bool get isLocked => !type.unlocked.first;

  @override
  Widget build(BuildContext context) {
    void play() {
      PersistedInt.gamesPlayed.value++;
      Navigator.of(context).pop();
      goTo(context, (context) => GameplayPage(initialBug: type), replace: true);
    }

    return AlertDialog(
      title: Text(isLocked ? "?????" : type.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BugPane(type: type, showName: false),
          Text(isLocked ? type.unlocked.second : type.description),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("go back"),
        ),
        if (!isLocked) ElevatedButton(onPressed: play, child: Text("Play")),
      ],
    );
  }
}
