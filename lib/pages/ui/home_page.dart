import 'package:flutter/material.dart';
import 'package:quail_57/pages/ui/home_page_background.dart';
import 'package:quail_57/select_bug/ui/select_bug_page.dart';
import 'package:quail_57/settings/ui/page_title.dart';
import 'package:quail_57/settings/ui/settings_page.dart';
import 'package:quail_57/shared/ui/app_scaffold.dart';
import 'package:quail_57/shared/ui/go_to.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      background: HomePageBackground(),
      child: _contents(context),
    );
  }

  Widget _contents(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: TitledPage(
          title: "TREPTH",
          subtitle: "Ludum Dare Edition",
          children: [
            SizedBox(height: 40),
            ElevatedButton(
              onPressed:
                  () => goTo(context, (context) => const SelectBugPage()),
              child: Text("Get In There"),
            ),
            ElevatedButton(
              onPressed: () => goTo(context, (context) => const SettingsPage()),
              child: Text("Settings"),
            ),
          ],
        ),
      ),
    );
  }
}
