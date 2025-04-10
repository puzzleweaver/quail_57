import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/emmy_type.dart';
import 'package:quail_57/gameplay/ui/animated_game_widget.dart';
import 'package:quail_57/gameplay/domain/tree.dart';
import 'package:quail_57/gameplay/ui/outcome_page.dart';
import 'package:quail_57/home/ui/are_you_sure_dialog.dart';
import 'package:quail_57/shared/ui/app_scaffold.dart';

class GameplayPage extends StatefulWidget {
  final EmmyType initialBug;

  const GameplayPage({super.key, required this.initialBug});

  @override
  State<StatefulWidget> createState() => GameplayPageState();
}

class GameplayPageState extends State<GameplayPage> {
  late Tree previous;
  late Tree tree;

  EmmyType get initialBug => widget.initialBug;

  @override
  void initState() {
    previous = tree = Tree.initial(initialBug);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (tree.isEndgame) {
      return OutcomePage(
        youWon: tree.youWon,
        kills: previous.you?.kills ?? 0,
        turnsSurvived: tree.turns,
      );
    }
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedGameWidget(size: size, tree: tree, setTree: setTree),
            ],
          ),
        ),
      ),
    );
  }

  void setTree(Tree newTree) {
    setState(() => tree = newTree);
  }
}
