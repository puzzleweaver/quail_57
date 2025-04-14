import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/settings/domain/persisted.dart';
import 'package:quail_57/shared/ui/pane/pane.dart';
import 'package:quail_57/shared/data/sprites.dart';

class BugPane extends StatefulWidget {
  final BugType type;
  final int? perScreen;

  const BugPane({super.key, required this.type, this.perScreen});

  @override
  State<StatefulWidget> createState() => BugPaneState();
}

class BugPaneState extends State<BugPane> {
  BugType get type => widget.type;

  late Timer timer;
  int idleValue = 0;

  @override
  void initState() {
    initIdleTimer();
    super.initState();
  }

  initIdleTimer() {
    timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        idleValue = idleValue == 0 ? 1 : 0; // Toggle between 0 and 1
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ui.Image? bugImage = type.frame(0);
    return Pane(
      perScreen: widget.perScreen,
      children: [
        image(context, bugImage),
        if (!type.isUnlocked) ...{shadowPane, image(context, Sprites.lock)},
        ...decorations,
      ],
    );
  }

  Widget get shadowPane {
    return Container(color: Colors.black.withAlpha(100));
  }

  List<Widget> get decorations {
    return [
      if (PersistedBugInt.gamesWon[type] > 0)
        Container(
          alignment: Alignment.bottomRight,
          child: Icon(Icons.star, color: Colors.orange, size: 28),
        ),
      // Container(
      //   alignment: Alignment.topLeft,
      //   child: Icon(Icons.flag, color: Colors.blue, size: 28),
      // ),
    ];
  }

  Widget image(BuildContext context, ui.Image? image) {
    if (image == null) return Container();
    return RawImage(
      image: image,
      fit: BoxFit.fill,
      filterQuality: FilterQuality.none,
    );
  }
}
