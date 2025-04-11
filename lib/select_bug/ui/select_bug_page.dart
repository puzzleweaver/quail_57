import 'package:flutter/material.dart';
import 'package:quail_57/gameplay/domain/entity/emmy_type.dart';
import 'package:quail_57/gameplay/ui/gameplay_page.dart';
import 'package:quail_57/settings/domain/persisted.dart';
import 'package:quail_57/shared/ui/go_to.dart';
import 'package:quail_57/select_bug/ui/select_bug_widget.dart';

class SelectBugPage extends StatefulWidget {
  const SelectBugPage({super.key});

  @override
  State<StatefulWidget> createState() => SelectBugPageState();
}

class SelectBugPageState extends State<SelectBugPage> {
  EmmyType type = EmmyType.all.first;

  double get hpad => 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Text("Select Bug"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SelectBugWidget(
                type: type,
                allTypes: EmmyType.all,
                setType: setType,
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  type.isUnlocked ? type.title : "?????",
                  style: textStyle,
                ),
              ),
              horizontalDivider,
              row(description, playButton),
              horizontalDivider,
              ...PersistedEmmyInt.all.expand(
                (pei) => [
                  row(
                    Text(
                      pei.titlePrefix,
                      style: textStyle,
                      textAlign: TextAlign.right,
                    ),
                    Text(pei[type].toString(), style: textStyle),
                  ),
                  horizontalDivider,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget get horizontalDivider =>
      Divider(height: 0, indent: hpad, endIndent: hpad);

  TextStyle get textStyle => TextStyle(color: Colors.white);

  Widget get description {
    return Container(
      height: 14 * 6,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10),
      child: Text(
        type.isUnlocked ? type.description : type.unlockDescription,
        style: textStyle,
      ),
    );
  }

  Widget get playButton {
    void play() {
      PersistedEmmyInt.gamesPlayed[type]++;
      Navigator.of(context).pop();
      goTo(context, (context) => GameplayPage(initialBug: type));
    }

    return Container(
      foregroundDecoration: BoxDecoration(
        color: type.isUnlocked ? null : Colors.black.withAlpha(100),
      ),
      child: ElevatedButton(
        onPressed: type.isUnlocked ? play : () {},
        child: Text("Play!"),
      ),
    );
  }

  void setType(EmmyType newType) {
    setState(() => type = newType);
  }

  Widget row(Widget item1, Widget item2) {
    return IntrinsicHeight(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: hpad),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VerticalDivider(width: 0),
            rowItem(item1, Alignment.centerRight),
            VerticalDivider(width: 0),
            rowItem(item2, Alignment.center),
            VerticalDivider(width: 0),
          ],
        ),
      ),
    );
  }

  Widget rowItem(Widget child, Alignment alignment) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width) / 2 - hpad,
      child: Container(
        margin: EdgeInsets.all(5),
        // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
        alignment: alignment,
        child: child,
      ),
    );
  }
}
