import 'package:flutter/material.dart';

class TitledPage extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const TitledPage({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [_titleWidget(), _subtitleWidget(), ...children],
      ),
    );
  }

  Widget _titleWidget() {
    return SizedBox(
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          "  $title  ",
          style: TextStyle(fontSize: 1000, color: Colors.white),
        ),
      ),
    );
  }

  Widget _subtitleWidget() {
    String? subtitle = this.subtitle;
    return subtitle == null
        ? Container()
        : Text(subtitle, style: TextStyle(color: Colors.white));
  }
}
