import 'package:quail_57/shared/data/static_shared_preferences.dart';

enum PersistedInt {
  animationSpeed("animation_speed", 350),
  gamesPlayed("games_played", 0),
  gamesWon("games_won", 0),
  maxTurnsSurvived("max_turns_survived", 0),
  maxKills("max_kills", 0),
  gamesLost("games_lost", 0);

  final String key;
  final int defaultValue;
  const PersistedInt(this.key, this.defaultValue);

  String get title {
    return switch (this) {
      // settings
      animationSpeed => "Animation Speed",

      // statistics
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

  int get value {
    return (StaticSharedPreferences.prefs.getInt(key) ?? defaultValue);
  }

  set value(int value) {
    StaticSharedPreferences.prefs.setInt(key, value);
  }
}
