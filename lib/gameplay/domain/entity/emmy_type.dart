import 'dart:ui' as ui;

import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/settings/domain/setting.dart';
import 'package:quail_57/shared/data/sprites.dart';
import 'package:quail_57/shared/ui/list_choice.dart';

enum EmmyType {
  antLarva(2, 6, 2),
  ant(5, 7, 6),
  antQueen(10, 0, 0),
  wasp(5, 0, 0),
  termite(5, 5, 4), // AVERAGE GUY
  bigTermite(7, 7, 5),
  grub(20, 3, 1)
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
  const EmmyType(this.health, this.attack, this.hungriness);

  static List<EmmyType> get all => [
    antLarva,
    ant,
    antQueen,
    wasp,
    termite,
    bigTermite,
    grub,
  ];

  List<ui.Image>? get images {
    return switch (this) {
      antLarva => Sprites.antLarva,
      EmmyType.ant => Sprites.ant,
      EmmyType.antQueen => Sprites.antQueen,
      EmmyType.wasp => Sprites.wasp,
      EmmyType.termite => Sprites.termite,
      EmmyType.bigTermite => Sprites.bigTermite,
      EmmyType.grub => Sprites.grub,
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
        EmmyType.antLarva => true,
        EmmyType.ant => true,
        EmmyType.antQueen => false,
        EmmyType.wasp => false,
        EmmyType.termite => true,
        EmmyType.bigTermite => false,
        EmmyType.grub => true,
      },
      FruitType.log => switch (this) {
        EmmyType.antLarva => false,
        EmmyType.ant => false,
        EmmyType.antQueen => false,
        EmmyType.wasp => false,
        EmmyType.termite => true,
        EmmyType.bigTermite => true,
        EmmyType.grub => true,
      },
    };
  }
}

extension EmmyTypeTables on EmmyType {
  String get title {
    return switch (this) {
      EmmyType.antLarva => "Ant Larva",
      EmmyType.ant => "Ant",
      EmmyType.antQueen => "Ant Queen",
      EmmyType.wasp => "Wasp",
      EmmyType.termite => "Termite",
      EmmyType.bigTermite => "Big Termite",
      EmmyType.grub => "Grub",
    };
  }

  String get difficulty {
    return switch (this) {
      EmmyType.antLarva => "hard",
      EmmyType.ant => "normal",
      EmmyType.antQueen => "hard",
      EmmyType.wasp => "hard",
      EmmyType.termite => "hard",
      EmmyType.bigTermite => "normal",
      EmmyType.grub => "easy",
    };
  }

  String get description {
    return switch (this) {
      EmmyType.antLarva => "These little fuckers are shit.",
      EmmyType.ant => "Ol' Reliable. Middle of the road kinda guy",
      EmmyType.antQueen =>
        "She poops out babies like theres no tomorrow. good luck",
      EmmyType.wasp => "Pointy",
      EmmyType.termite => "This guy eats wood",
      EmmyType.bigTermite => "Still eatin wood",
      EmmyType.grub => "These make me uncomfortable...",
    };
  }

  (bool, String) get unlocked {
    return switch (this) {
      EmmyType.antLarva => (false, "do you really want to play as a worm?"),
      EmmyType.ant => (true, "unlocked by default"),
      EmmyType.antQueen => (
        false,
        "i don't think you can unlock her at all right now actually !",
      ),
      EmmyType.wasp => (Settings.gamesWon > 0, "beat the game."),
      EmmyType.termite => (true, "unlocked by default."),
      EmmyType.bigTermite => (Settings.gamesWon > 0, "beat the game."),
      EmmyType.grub => (Settings.gamesPlayed >= 3, "play 3 rounds."),
    };
  }
}
