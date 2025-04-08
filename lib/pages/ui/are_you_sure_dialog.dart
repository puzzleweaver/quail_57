import 'package:flutter/material.dart';

class AreYouSureDialog extends StatelessWidget {
  final Widget title;
  final Widget message;
  final Widget cancel;
  final Widget confirm;

  const AreYouSureDialog({
    super.key,
    required this.title,
    required this.message,
    required this.cancel,
    required this.confirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: title),
      content: message,
      actions: [
        ElevatedButton(onPressed: () => pop(context, false), child: cancel),
        ElevatedButton(onPressed: () => pop(context, true), child: confirm),
      ],
    );
  }

  void pop(BuildContext context, bool confirm) {
    NavigatorState navigator = Navigator.of(context, rootNavigator: true);
    Future.delayed(Duration.zero, () {
      navigator.pop(confirm);
    });
  }
}
