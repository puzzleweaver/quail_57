import 'dart:math';

import 'package:quail_57/gameplay/domain/entity/emmy.dart';
import 'package:quail_57/gameplay/domain/entity/emmy_type.dart';
import 'package:quail_57/gameplay/domain/entity/entity.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/geometry/bitri.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/geometry/tri.dart';
import 'package:quail_57/gameplay/domain/space.dart';
import 'package:quail_57/gameplay/domain/space_type.dart';
import 'package:quail_57/shared/ui/list_choice.dart';
import 'package:quail_57/shared/ui/map_range_pick.dart';

class Generate {
  static BiTri biTri({bool allowMiddle = false}) {
    BiTri ret = BiTri(Tri.random, Tri.random);
    if (!allowMiddle && ret.isMiddle) return biTri(allowMiddle: allowMiddle);
    return ret;
  }

  static Coordinate coordinate(int length, {BiTri? last}) {
    return Coordinate([
      for (int i = 0; i < length; i++)
        if (i == length - 1) (last ?? biTri()) else biTri(),
    ], 0);
  }

  static bool rollChance(double chance) {
    return Random().nextDouble() < chance;
  }

  static SpaceType spaceType(int depth) {
    if (rollChance(goalChance(depth))) return SpaceType.goal;
    List<SpaceType> darkLeafZone = [SpaceType.darkLeaf],
        lightLeafZone = [SpaceType.lightLeaf],
        barkZone = [SpaceType.bark],
        softwoodZone = [SpaceType.softwood1, SpaceType.softwood2],
        hardwoodZone = [SpaceType.hardwood1, SpaceType.hardwood2],
        dirtZone = [SpaceType.dirt];
    return {
      (null, -5): lightLeafZone,
      (-5, -1): lightLeafZone + darkLeafZone,
      (-1, 1): darkLeafZone,
      (1, 6): darkLeafZone + barkZone,
      (6, 7): barkZone,
      (7, 8): barkZone + hardwoodZone,
      (8, 17): hardwoodZone,
      (17, 19): hardwoodZone + softwoodZone,
      (19, 29): softwoodZone,
      (29, 39): softwoodZone + dirtZone,
      (39, null): dirtZone,
    }.rangePick(depth, darkLeafZone).choice;
  }

  static Space space(int depth) {
    SpaceType type = spaceType(depth);
    Entity? entity;
    if (rollChance(emmyChance(depth))) entity = Generate.emmy(type);
    if (rollChance(logChance(type))) {
      entity = Fruit(fruitType: FruitType.log, id: Generate.id);
    }
    if (rollChance(appleChance(type))) {
      entity = Fruit(fruitType: FruitType.apple, id: Generate.id);
    }
    return Space(
      entity: entity,
      hasFloor: Random().nextDouble() < 0.5,
      type: type,
    );
  }

  static double emmyChance(int depth) {
    if (depth < -15) return 0.2;
    return 0.1;
  }

  static double appleChance(SpaceType type) {
    return switch (type) {
      SpaceType.softwood1 => 0.1,
      SpaceType.softwood2 => 0.15,
      SpaceType.hardwood1 => 0.01,
      SpaceType.hardwood2 => 0.01,
      SpaceType.darkLeaf => 0.3,
      SpaceType.lightLeaf => 0.25,
      SpaceType.bark => 0.0,
      SpaceType.dirt => 0.0,
      SpaceType.goal => 0.0,
    };
  }

  static double logChance(SpaceType type) {
    return switch (type) {
      SpaceType.softwood1 => 0.2,
      SpaceType.softwood2 => 0.2,
      SpaceType.hardwood1 => 0.3,
      SpaceType.hardwood2 => 0.3,
      SpaceType.darkLeaf => 0.05,
      SpaceType.lightLeaf => 0.0,
      SpaceType.bark => 0.1,
      SpaceType.dirt => 0.1,
      SpaceType.goal => 0.0,
    };
  }

  static double goalChance(int depth) {
    if (depth > 30) return 0.05;
    if (depth > 40) return 0.2;
    return 0.0;
  }

  static Fruit fruit(int depth) {
    return Fruit(fruitType: FruitType.all.choice, id: Generate.id);
  }

  static Emmy? emmy(SpaceType type) {
    EmmyType? emmyType = Generate.emmyType(type);
    if (emmyType == null) return null;
    return Emmy.create(emmyType);
  }

  static EmmyType? emmyType(SpaceType type) {
    // ignore: prefer_function_declarations_over_variables
    switch (type) {
      case SpaceType.lightLeaf:
        return EmmyType.wasp;
      case SpaceType.bark:
      case SpaceType.darkLeaf:
        return [
          EmmyType.termite,
          EmmyType.ant,
          EmmyType.antLarva,
          EmmyType.antLarva,
        ].choice;
      case SpaceType.hardwood2:
      case SpaceType.softwood2:
        return [EmmyType.ant, EmmyType.termite].choice;
      case SpaceType.softwood1:
      case SpaceType.hardwood1:
        return [EmmyType.ant, EmmyType.bigTermite].choice;
      case SpaceType.dirt:
        return [
          EmmyType.grub,
          EmmyType.wasp,
          EmmyType.termite,
          EmmyType.bigTermite,
          EmmyType.antQueen,
        ].choice;
      case SpaceType.goal:
        return null;
    }
  }

  static final int _idSize = 10000000;
  static String get id => (Random().nextInt(_idSize) + _idSize).toString();
}
