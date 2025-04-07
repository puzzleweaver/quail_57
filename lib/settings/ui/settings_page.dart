import 'package:flutter/material.dart';
import 'package:quail_57/settings/domain/setting.dart';
import 'package:quail_57/settings/ui/page_title.dart';
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
              SettingWidget(field: SettingField.animationSpeed),
              // SettingWidget(field: SettingField.animationSpeed),
            ],
          ),
        ),
      ),
    );
  }
}
