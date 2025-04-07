import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/emmy.dart';
import 'package:quail_57/gameplay/domain/entity/emmy_tables.dart';
import 'package:quail_57/gameplay/ui/gameplay_page.dart';
import 'package:quail_57/shared/data/assets.dart';
import 'package:quail_57/shared/ui/go_to.dart';
import 'package:quail_57/shared/ui/size_is_tall.dart';

class BugSelectionButton extends StatelessWidget {
  final EmmyType type;

  const BugSelectionButton({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    onPressed() {
      goTo(context, (context) => GameplayPage(initialBug: type), replace: true);
    }

    double lesser = MediaQuery.of(context).size.lesser;
    ui.Image? image = type.frame(0);
    if (image == null) return Image.asset(Assets.goal);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox.square(
              dimension: lesser / 3.5,
              child: RawImage(
                image: image,
                fit: BoxFit.fill,
                filterQuality: FilterQuality.none,
              ),
            ),
            Text([type.title, "(${type.difficulty})"].join("\n")),
          ],
        ),
      ),
    );
  }
}
