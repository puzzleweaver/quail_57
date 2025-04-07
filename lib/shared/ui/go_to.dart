import 'package:flutter/material.dart';

void goTo(
  BuildContext context,
  Widget Function(BuildContext) builder, {
  bool replace = false,
}) {
  final navigator = Navigator.of(context);
  if (!replace) {
    navigator.push(MaterialPageRoute(builder: builder));
  } else {
    navigator.pushReplacement(MaterialPageRoute(builder: builder));
  }
}
