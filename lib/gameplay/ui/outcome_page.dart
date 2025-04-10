import 'package:flutter/material.dart';
import 'package:quail_57/settings/domain/persisted.dart';
import 'package:quail_57/settings/ui/page_title.dart';
import 'package:quail_57/shared/ui/app_scaffold.dart';

class OutcomePage extends StatefulWidget {
  final int turnsSurvived;
  final int kills;
  final bool youWon;
  // TODO stats?

  const OutcomePage({
    super.key,
    required this.youWon,
    required this.kills,
    required this.turnsSurvived,
  });

  @override
  State<StatefulWidget> createState() => OutcomePageState();
}

class OutcomePageState extends State<OutcomePage> {
  @override
  void initState() {
    // update statistics
    if (!widget.youWon) PersistedInt.gamesLost.value++;
    if (widget.youWon) PersistedInt.gamesWon.value++;

    if (widget.turnsSurvived > PersistedInt.maxTurnsSurvived.value) {
      PersistedInt.maxTurnsSurvived.value = widget.turnsSurvived;
    }

    if (widget.kills > PersistedInt.maxKills.value) {
      PersistedInt.maxKills.value = widget.kills;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: TitledPage(
            title: widget.youWon ? "You Won!" : "You Died.",
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  [
                    "Your stats were:",
                    "Kills: ${widget.kills}",
                    "Turns Survived: ${widget.turnsSurvived}",
                  ].join("\n"),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("back to menu"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
