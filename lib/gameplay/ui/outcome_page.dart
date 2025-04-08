import 'package:flutter/material.dart';
import 'package:quail_57/settings/domain/setting.dart';
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
    if (!widget.youWon) SettingField.gamesLost.setValue(Settings.gamesLost + 1);
    if (widget.youWon) SettingField.gamesWon.setValue(Settings.gamesWon + 1);
    if (widget.turnsSurvived > Settings.maxTurnsSurvived) {
      SettingField.maxTurnsSurvived.setValue(widget.turnsSurvived);
    }
    if (widget.kills > Settings.maxKills) {
      SettingField.maxKills.setValue(widget.kills);
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
