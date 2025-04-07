import 'package:quail_57/gameplay/domain/entity/emmy.dart';

extension EmmyTables on Emmy {
  bool canEat(Emmy other) {
    return emmyType.health > other.emmyType.health;
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
}
