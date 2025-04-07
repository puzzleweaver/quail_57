import 'package:flutter/material.dart';
import 'package:quail_57/home/ui/home_page.dart';
import 'package:quail_57/settings/domain/setting.dart';
import 'package:quail_57/shared/data/sprites.dart';

void main() async {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quail 57',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade900),
      ),
      home: FutureBuilder(
        future: Future.wait([Sprites.init(), Settings.init()])
            .then((_) => "Done! :3")
            .catchError(
              (error) => print("Spritin' (or Settin?) failed: $error"),
            ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
