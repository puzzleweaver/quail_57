import 'package:flutter/material.dart';
import 'package:quail_57/settings/domain/persisted.dart';
import 'package:quail_57/settings/ui/titled_page.dart';
import 'package:quail_57/settings/ui/setting_widget.dart';
import 'package:quail_57/shared/ui/app_scaffold.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Center(
        child: SingleChildScrollView(
          child: TitledPage(
            title: "Settings",
            children: [
              SettingWidget(field: PersistedInt.animationSpeed),
              // SettingWidget(field: SettingField.animationSpeed),
              // status(SettingField.maxKills, Settings.maxKills),
              // status(SettingField.gamesLost, Settings.gamesLost),
              // status(SettingField.gamesWon, Settings.gamesWon),
              // status(SettingField.gamesPlayed, Settings.gamesPlayed),
              // status(SettingField.maxTurnsSurvived, Settings.maxTurnsSurvived),
            ],
          ),
        ),
      ),
    );
  }

  Widget status(PersistedInt field, dynamic value) {
    return Text(
      "${field.title}: $value",
      style: TextStyle(color: Colors.white),
    );
  }
}
