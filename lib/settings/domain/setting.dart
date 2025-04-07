import 'package:shared_preferences/shared_preferences.dart';

enum SettingField<T> {
  animationSpeed("animation_speed", 350);

  final String key;
  final T defaultValue;
  const SettingField(this.key, this.defaultValue);

  String get title {
    return switch (this) {
      animationSpeed => "Animation Speed",
    };
  }

  List<(dynamic, String)> get options {
    return switch (this) {
      animationSpeed => [
        (100, "Fast"),
        (350, "Normal"),
        (700, "Slow"),
        (0, "Off"),
      ],
    };
  }

  bool isValue(dynamic value) {
    return switch (this) {
      animationSpeed => Settings.animationSpeed == value,
    };
  }

  void setValue(dynamic value) {
    if (T is int) Settings.prefs.setInt(key, value);
    if (T is double) Settings.prefs.setDouble(key, value);
    if (T is String) Settings.prefs.setString(key, value);
    switch (this) {
      case animationSpeed:
        Settings.animationSpeed = value;
      // ignore: unreachable_switch_case
      case _:
        throw UnimplementedError();
    }
  }
}

class Settings {
  static SharedPreferences? sp;

  // duration in milliseconds of the
  static int animationSpeed = SettingField.animationSpeed.defaultValue;

  static SharedPreferences get prefs {
    SharedPreferences? ret = sp;
    if (ret == null) {
      throw UnimplementedError(
        "Make sure to call Settings.init before accessing settings :P",
      );
    }
    return ret;
  }

  static int getInt(SettingField<int> field) =>
      prefs.getInt(field.key) ?? field.defaultValue;
  static double getDouble(SettingField<double> field) =>
      prefs.getDouble(field.key) ?? field.defaultValue;
  static String getString(SettingField<String> field) =>
      prefs.getString(field.key) ?? field.defaultValue;

  static Future<void> init() async {
    print("called..");
    sp = await SharedPreferences.getInstance();
    print("instantiated..");
    animationSpeed = getInt(SettingField.animationSpeed);
    print("Done?");
    return;
  }
}

// ignore: constant_identifier_names
enum SettingType { STRING, INT, DOUBLE }
