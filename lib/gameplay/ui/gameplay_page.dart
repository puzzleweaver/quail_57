import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/gameplay/domain/game/game.dart';
import 'package:quail_57/gameplay/ui/animated_game_widget.dart';
import 'package:quail_57/gameplay/ui/gameplay_back_interceptor.dart';
import 'package:quail_57/gameplay/ui/outcome_page.dart';

class GameplayPage extends StatefulWidget {
  final BugType initialBug;

  const GameplayPage({super.key, required this.initialBug});

  @override
  State<StatefulWidget> createState() => GameplayPageState();
}

class GameplayPageState extends State<GameplayPage> {
  late Game game;

  BugType get initialBug => widget.initialBug;

  @override
  void initState() {
    game = Game.initial(initialBug);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (game.isEndgame) return OutcomePage(game: game);
    Size size = MediaQuery.of(context).size;
    double dim = min(size.width, size.height);
    size = Size(dim, dim);
    return GameplayBackInterceptor(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text("Hello"),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedGameWidget(
                size: size,
                game: game,
                setGame: (newGame) {
                  setState(() => game = newGame);
                },
              ),
              Expanded(
                child: Container(
                  color: Colors.black,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Health: ${game.you?.health}\nFullness: ${game.you?.belly}",
                        style: TextStyle(color: Colors.white),
                      ),
                      Divider(indent: 30, endIndent: 30),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Text(
                            game.activityLog.reversed.join("\n"),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
