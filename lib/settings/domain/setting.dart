import 'package:shared_preferences/shared_preferences.dart';

enum SettingField<T> {
  animationSpeed("animation_speed", 350),
  gamesPlayed("games_played", 0),
  gamesWon("games_won", 0),
  maxTurnsSurvived("max_turns_survived", 0),
  maxKills("max_kills", 0),
  gamesLost("games_lost", 0);

  final String key;
  final T defaultValue;
  const SettingField(this.key, this.defaultValue);

  String get title {
    return switch (this) {
      animationSpeed => "Animation Speed",
      gamesPlayed => "Games Played",
      gamesWon => "Games Won",
      gamesLost => "Games Lost",
      maxTurnsSurvived => "Maximum Turns Survived",
      maxKills => "Maximum Kills",
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
      _ => throw UnimplementedError("Is $this actually a setting?"),
    };
  }

  bool isValue(dynamic value) {
    return switch (this) {
      animationSpeed => Settings.animationSpeed == value,
      _ => false, // who cares
    };
  }

  void setValue(dynamic value) {
    if (T is int) Settings.prefs.setInt(key, value);
    if (T is double) Settings.prefs.setDouble(key, value);
    if (T is String) Settings.prefs.setString(key, value);
    switch (this) {
      case animationSpeed:
        Settings.animationSpeed = value;
      case maxTurnsSurvived:
        Settings.maxTurnsSurvived = value;
      case maxKills:
        Settings.maxKills = value;
      case gamesPlayed:
        Settings.gamesPlayed = value;
      case gamesLost:
        Settings.gamesLost = value;
      case gamesWon:
        Settings.gamesWon = value;
      // ignore: unreachable_switch_case
      case _:
        throw UnimplementedError();
    }
  }
}

class Settings {
  static SharedPreferences? sp;

  // duration in milliseconds of the player movement animation
  static int animationSpeed = SettingField.animationSpeed.defaultValue;
  static int gamesPlayed = SettingField.gamesPlayed.defaultValue;
  static int gamesWon = SettingField.gamesWon.defaultValue;
  static int gamesLost = SettingField.gamesLost.defaultValue;
  static int maxTurnsSurvived = SettingField.maxTurnsSurvived.defaultValue;
  static int maxKills = SettingField.maxKills.defaultValue;

  static SharedPreferences get prefs {
    SharedPreferences? ret = sp;
    if (ret == null) {
      throw UnimplementedError(
        "Make sure to call Settings.init before accessing settings :P",
      );
    }
    return ret;
  }

  static dynamic valueOf<T>(SettingField<T> field) {
    return Settings.prefs.get(field.key);
  }

  static int getInt(SettingField<int> field) =>
      prefs.getInt(field.key) ?? field.defaultValue;
  static double getDouble(SettingField<double> field) =>
      prefs.getDouble(field.key) ?? field.defaultValue;
  static String getString(SettingField<String> field) =>
      prefs.getString(field.key) ?? field.defaultValue;

  static Future<void> init() async {
    sp = await SharedPreferences.getInstance();
    animationSpeed = getInt(SettingField.animationSpeed);
    gamesPlayed = getInt(SettingField.gamesPlayed);
    gamesLost = getInt(SettingField.gamesLost);
    gamesWon = getInt(SettingField.gamesWon);
    maxKills = getInt(SettingField.maxKills);
    maxTurnsSurvived = getInt(SettingField.maxTurnsSurvived);
    return;
  }
}

// ignore: constant_identifier_names
enum SettingType { STRING, INT, DOUBLE }
