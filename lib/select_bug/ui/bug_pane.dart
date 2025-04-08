import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/emmy_type.dart';
import 'package:quail_57/shared/data/sprites.dart';
import 'package:quail_57/shared/ui/pair_first_second.dart';
import 'package:quail_57/shared/ui/size_is_tall.dart';

class BugPane extends StatefulWidget {
  final bool showName;
  final EmmyType type;

  const BugPane({super.key, required this.type, required this.showName});

  @override
  State<StatefulWidget> createState() => BugPaneState();
}

class BugPaneState extends State<BugPane> {
  EmmyType get type => widget.type;
  bool get showName => widget.showName;
  bool get isLocked => !type.unlocked.first;

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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        image(context, bugImage),
        if (showName) Text(isLocked ? "" : type.title),
        if (isLocked) ...{shadowPane(context), image(context, Sprites.lock)},
      ],
    );
  }

  Widget shadowPane(BuildContext context) {
    return square(
      context: context,
      child: Container(color: Colors.black.withAlpha(100)),
    );
  }

  Widget image(BuildContext context, ui.Image? image) {
    if (image == null) return Container();
    return square(
      context: context,
      child: RawImage(
        image: image,
        fit: BoxFit.fill,
        filterQuality: FilterQuality.none,
      ),
    );
  }

  Widget square({required BuildContext context, required Widget child}) {
    double lesser = MediaQuery.of(context).size.lesser;
    return SizedBox.square(dimension: lesser / 3.5, child: child);
  }
}
