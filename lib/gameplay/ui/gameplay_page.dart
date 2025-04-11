import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/gameplay/domain/turn.dart';
import 'package:quail_57/gameplay/ui/animated_game_widget.dart';
import 'package:quail_57/gameplay/ui/outcome_page.dart';
import 'package:quail_57/home/ui/are_you_sure_dialog.dart';
import 'package:quail_57/shared/ui/app_scaffold.dart';

class GameplayPage extends StatefulWidget {
  final BugType initialBug;

  const GameplayPage({super.key, required this.initialBug});

  @override
  State<StatefulWidget> createState() => GameplayPageState();
}

class GameplayPageState extends State<GameplayPage> {
  late Turn turn;

  BugType get initialBug => widget.initialBug;

  @override
  void initState() {
    turn = Turn.initial(initialBug);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (turn.isEndgame) return OutcomePage(turn: turn);
    Size size = MediaQuery.of(context).size;
    double dim = min(size.width, size.height);
    size = Size(dim, dim);
    return PopScope<bool>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop =
            await showDialog(
              context: context,
              builder:
                  (context) => AreYouSureDialog(
                    title: Text("Exit Game?"),
                    message: Text("Your progress will not be saved."),
                    cancel: Text("continue playing"),
                    confirm: Text("exit"),
                  ),
            ) ??
            false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: AppScaffold(
        title: Text("${turn.you?.health} | ${turn.you?.belly}"),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedGameWidget(
                size: size,
                turn: turn,
                setTurn: (newTurn) {
                  setState(() => turn = newTurn);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
