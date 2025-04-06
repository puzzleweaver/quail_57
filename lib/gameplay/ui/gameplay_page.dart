import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/ui/animated_game_widget.dart';
import 'package:quail_57/math/tree.dart';

class GameplayPage extends StatefulWidget {
  const GameplayPage({super.key});

  @override
  State<StatefulWidget> createState() => GameplayPageState();
}

class GameplayPageState extends State<GameplayPage> {
  Tree tree = Tree.initial();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double dim = min(size.width, size.height);
    size = Size(dim, dim);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text("REMOVE MEEEEE")),
      body: Center(
        child: AnimatedGameWidget(size: size, tree: tree, setTree: setTree),
      ),
    );
  }

  void setTree(Tree newTree) => setState(() => tree = newTree);
}
