import 'package:flutter/material.dart';
import 'package:quail_57/my_home_page.dart';
import 'package:quail_57/shared/data/sprites.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quail 57',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade900),
      ),
      home: FutureBuilder(
        future: Sprites.init().catchError((error) {
          print("Spritin' failed: $error");
        }),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const MyHomePage();
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
