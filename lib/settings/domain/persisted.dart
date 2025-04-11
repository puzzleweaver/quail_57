import 'dart:math';

import 'package:quail_57/gameplay/domain/entity/emmy_type.dart';
import 'package:quail_57/shared/data/static_persistence.dart';

enum PersistedInt {
  animationSpeed("animation_speed", 350),
  garbajo("Trash!", -42);

  final String key;
  final int defaultValue;
  const PersistedInt(this.key, this.defaultValue);

  String get title {
    return switch (this) {
      // settings
      animationSpeed => "Animation Speed",
      _ => "FUCK YOU buddy",
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
      _ => [],
    };
  }

  int get value => StaticPersistence.getInt(key) ?? defaultValue;
  set value(int value) => StaticPersistence.setInt(key, value);
}

enum PersistedEmmyInt {
  gamesWon("times_won", Method.add),
  gamesLost("times_lost", Method.add),
  gamesPlayed("times_played_as", Method.add),
  timesKilled("times_killed", Method.add),
  timesKilledBy("times_killed_by", Method.add),
  maxTurnsSurvived("max_turns_survived", Method.maximize),
  maxKills("max_kills", Method.maximize),
  minTurnsToWin("min_turns_to_win", Method.minimize);

  final String keyPrefix;
  final Method method;

  const PersistedEmmyInt(this.keyPrefix, this.method);
  String key(EmmyType type) => "${keyPrefix}_$type";

  static List<PersistedEmmyInt> get all => [
    gamesWon,
    gamesLost,
    gamesPlayed,
    timesKilled,
    timesKilledBy,
    maxTurnsSurvived,
    maxKills,
  ];

  String title(EmmyType type) => "$titlePrefix ${type.title}";
  String get titlePrefix {
    return switch (this) {
      gamesWon => "Games Won",
      gamesLost => "Games Lost",
      gamesPlayed => "Games Played",
      timesKilled => "Times Killed",
      timesKilledBy => "Tiles Killed",
      maxTurnsSurvived => "Maximum Turns Survived",
      minTurnsToWin => "Minimum Turns to Victory",
      maxKills => "Maximum Kills",
    };
  }

  // get/set by type
  int operator [](EmmyType type) => StaticPersistence.getInt(key(type)) ?? 0;
  operator []=(EmmyType type, int newValue) =>
      StaticPersistence.setInt(key(type), newValue);

  // sum of data in all fields.
  int get total =>
      EmmyType.all.map((type) => this[type]).reduce((a, b) => a + b);
}

enum Method {
  add,
  maximize,
  minimize;

  int Function(int, int) get combine {
    return switch (this) {
      add => (a, b) => a + b,
      maximize => max,
      minimize => min,
    };
  }
}
