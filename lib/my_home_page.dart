import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/ui/gameplay_page.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tree Search")),
      body: Center(
        child: Wrap(
          children: [
            ElevatedButton(
              onPressed: () => goToGameplay(context),
              child: Text("Play It"),
            ),
          ],
        ),
      ),
    );
  }

  void goToGameplay(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.push(MaterialPageRoute(builder: (context) => GameplayPage()));
  }
}
