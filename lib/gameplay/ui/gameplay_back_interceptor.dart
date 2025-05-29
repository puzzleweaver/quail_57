import 'package:flutter/material.dart';
import 'package:quail_57/home/ui/are_you_sure_dialog.dart';

class GameplayBackInterceptor extends StatelessWidget {
  final Widget child;

  const GameplayBackInterceptor({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope<bool>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop =
            await showDialog(
              context: context,
              builder:
                  (context) => AreYouSureDialog(
                    title: Text("Exit Game?"),
                    message: Text("Your progress will not be saved."),
                    cancel: Text("continue playing"),
                    confirm: Text("exit"),
                  ),
            ) ??
            false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: child,
    );
  }
}
