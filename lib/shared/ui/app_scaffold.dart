import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final Widget? background;
  final Widget? title;

  const AppScaffold({
    super.key,
    required this.child,
    this.background,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: title,
      ),
      body: Stack(children: [background ?? defaultBackground, child]),
    );
  }

  Widget get defaultBackground {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Container(color: Colors.black),
    );
  }
}
