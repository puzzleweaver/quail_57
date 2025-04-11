import 'dart:ui' as ui;

import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/settings/domain/persisted.dart';
import 'package:quail_57/shared/data/sprites.dart';
import 'package:quail_57/shared/ui/list_choice.dart';
import 'package:quail_57/shared/ui/pair_first_second.dart';

enum BugType {
  ant(5, 7, 6),
  termite(5, 5, 4), // AVERAGE GUY
  bigTermite(7, 7, 5),
  grub(20, 3, 1),
  antLarva(2, 6, 2),
  wasp(5, 0, 0),
  antQueen(10, 0, 0)
  // yet unimplemented:
  // scarab(0, 0, 0),
  // tarantula(0, 0, 0),
  // beetle(0, 0, 0),
  ;

  // 1 is "immediately dies", 5 is "takes a hit", 10 is "takes 3+ hits"
  final int health;
  // 1 is "barely touches you", 5 is "hits you", 10 is "immediately kills you"
  final int attack;
  // 1 is "barely has hunger", 5 is "needs food sometimes", 10 is "constantly eating"
  final int hungriness;
  const BugType(this.health, this.attack, this.hungriness);

  // order (kind of) matters here.
  static List<BugType> get all => [
    ant,
    termite,
    bigTermite,
    grub,
    antLarva,
    wasp,
    antQueen,
  ];

  List<ui.Image>? get images {
    return switch (this) {
      antLarva => Sprites.antLarva,
      BugType.ant => Sprites.ant,
      BugType.antQueen => Sprites.antQueen,
      BugType.wasp => Sprites.wasp,
      BugType.termite => Sprites.termite,
      BugType.bigTermite => Sprites.bigTermite,
      BugType.grub => Sprites.grub,
    };
  }

  ui.Image? frame(int idleValue) {
    switch (this) {
      case antLarva:
      case grub:
        return images?[idleValue];
      case _:
        return images?.choice;
    }
  }

  bool canEatFruit(FruitType fruit) {
    return switch (fruit) {
      FruitType.apple => switch (this) {
        BugType.antLarva => true,
        BugType.ant => true,
        BugType.antQueen => false,
        BugType.wasp => false,
        BugType.termite => true,
        BugType.bigTermite => false,
        BugType.grub => true,
      },
      FruitType.log => switch (this) {
        BugType.antLarva => false,
        BugType.ant => false,
        BugType.antQueen => false,
        BugType.wasp => false,
        BugType.termite => true,
        BugType.bigTermite => true,
        BugType.grub => true,
      },
    };
  }
}

extension BugTypeTables on BugType {
  String get title {
    return switch (this) {
      BugType.antLarva => "Ant Larva",
      BugType.ant => "Ant",
      BugType.antQueen => "Ant Queen",
      BugType.wasp => "Wasp",
      BugType.termite => "Termite",
      BugType.bigTermite => "Big Termite",
      BugType.grub => "Grub",
    };
  }

  String get difficulty {
    return switch (this) {
      BugType.antLarva => "hard",
      BugType.ant => "normal",
      BugType.antQueen => "hard",
      BugType.wasp => "hard",
      BugType.termite => "hard",
      BugType.bigTermite => "normal",
      BugType.grub => "easy",
    };
  }

  String get description {
    return switch (this) {
      BugType.antLarva => "These little fuckers are shit.",
      BugType.ant => "Ol' Reliable. Middle of the road kinda guy",
      BugType.antQueen =>
        "She poops out babies like theres no tomorrow. good luck",
      BugType.wasp => "Pointy",
      BugType.termite => "This guy eats wood",
      BugType.bigTermite => "Still eatin wood",
      BugType.grub => "These make me uncomfortable...",
    };
  }

  bool get isUnlocked => _unlocked.first;
  String get unlockDescription => _unlocked.second;
  (bool, String) get _unlocked {
    return switch (this) {
      BugType.antLarva => (false, "do you really want to play as a worm?"),
      BugType.ant => (true, "unlocked by default"),
      BugType.antQueen => (
        false,
        "i don't think you can unlock her at all right now actually !",
      ),
      BugType.wasp => (PersistedBugInt.gamesWon.total > 0, "beat the game :)"),
      BugType.termite => (true, "unlocked by default."),
      BugType.bigTermite => (
        PersistedBugInt.gamesWon.total > 0,
        "beat the game.",
      ),
      BugType.grub => (
        PersistedBugInt.gamesPlayed.total >= 3,
        "play 3 rounds.",
      ),
    };
  }
}
