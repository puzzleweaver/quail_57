import 'package:flutter/material.dart';
import 'package:quail_57/settings/domain/persisted.dart';
import 'package:quail_57/shared/ui/pair_first_second.dart';

class SettingWidget extends StatefulWidget {
  final PersistedInt field;
  const SettingWidget({super.key, required this.field});

  @override
  State<StatefulWidget> createState() => SettingWidgetState();
}

class SettingWidgetState extends State<SettingWidget> {
  PersistedInt get field => widget.field;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 10,
        runSpacing: 10,
        children: [
          SizedBox(
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "${field.title}: ${field.title.codeUnits.map((_) => " ").join("")}",
                style: TextStyle(color: Colors.white, fontSize: 1000),
              ),
            ),
          ),
          for ((dynamic, String) option in field.options)
            optionButton(context, option.first, option.second),
        ],
      ),
    );
  }

  Widget optionButton(BuildContext context, dynamic value, String optionTitle) {
    void onPressed() {
      field.value = value;
      setState(() {});
    }

    bool isSelected = field.value == value;

    final scheme = Theme.of(context).buttonTheme.colorScheme;
    Color? buttonBackground = scheme?.onPrimary.withAlpha(150);
    Color? buttonForeground = scheme?.primary.withAlpha(150);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? buttonBackground : null,
        foregroundColor: isSelected ? buttonForeground : null,
      ),
      onPressed: isSelected ? () {} : onPressed,
      child: Text(optionTitle),
    );
  }
}
