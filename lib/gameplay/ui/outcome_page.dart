import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/gameplay/domain/game/game.dart';
import 'package:quail_57/settings/domain/persisted.dart';
import 'package:quail_57/settings/ui/titled_page.dart';
import 'package:quail_57/shared/ui/app_scaffold.dart';

class OutcomePage extends StatefulWidget {
  final Game game;

  const OutcomePage({super.key, required this.game});

  @override
  State<StatefulWidget> createState() => OutcomePageState();
}

class OutcomePageState extends State<OutcomePage> {
  Game get game => widget.game;

  @override
  void initState() {
    updateStats();
    super.initState();
  }

  void updateStats() {
    BugType type = game.you!.type;
    if (game.youWon) PersistedBugInt.gamesWon[type]++;
    if (game.youLost) PersistedBugInt.gamesLost[type]++;
    PersistedBugInt.maxKills[type] = max(
      PersistedBugInt.maxKills[type],
      game.you?.kills ?? 0,
    );
    PersistedBugInt.maxTurnsSurvived[type] = max(
      PersistedBugInt.maxTurnsSurvived[type],
      game.index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: TitledPage(
            title: game.youWon ? "You Won!" : "You Died.",
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  ["Your stats were:", "TODO lmao"].join("\n"),
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
