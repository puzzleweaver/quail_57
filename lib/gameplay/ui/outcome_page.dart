import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/tree.dart';
import 'package:quail_57/settings/ui/titled_page.dart';
import 'package:quail_57/shared/ui/app_scaffold.dart';

class OutcomePage extends StatefulWidget {
  final Tree tree;

  const OutcomePage({super.key, required this.tree});

  @override
  State<StatefulWidget> createState() => OutcomePageState();
}

class OutcomePageState extends State<OutcomePage> {
  Tree get tree => widget.tree;

  bool get youWon => tree.youWon;

  @override
  void initState() {
    // TODO update statistics
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: TitledPage(
            title: youWon ? "You Won!" : "You Died.",
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
