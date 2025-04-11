import 'dart:math';

import 'package:quail_57/gameplay/domain/entity/bug.dart';
import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/geometry/bitri.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/geometry/tri.dart';
import 'package:quail_57/gameplay/domain/tile.dart';
import 'package:quail_57/gameplay/domain/tile_type.dart';
import 'package:quail_57/shared/ui/double_roll.dart';
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

  static TileType spaceType(int depth) {
    if (goalChance(depth).roll) return TileType.goal;
    List<TileType> darkLeafZone = [TileType.darkLeaf],
        lightLeafZone = [TileType.lightLeaf],
        barkZone = [TileType.bark],
        softwoodZone = [TileType.softwood1, TileType.softwood2],
        hardwoodZone = [TileType.hardwood1, TileType.hardwood2],
        dirtZone = [TileType.dirt];
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

  static Tile tile(int depth) {
    TileType type = spaceType(depth);
    bool hasFloor = 0.5.roll;
    return Tile(
      bug: bug(type),
      fruit: hasFloor ? fruit(type) : null,
      hasFloor: hasFloor,
      type: type,
    );
  }

  static double bugChance(int depth) {
    if (depth < -15) return 0.2;
    return 0.1;
  }

  static double goalChance(int depth) {
    if (depth > 30) return 0.05;
    if (depth > 40) return 0.2;
    return 0.0;
  }

  static Fruit? fruit(TileType type) {
    if (type.logChance.roll) return Fruit.log;
    if (type.appleChance.roll) return Fruit.apple;
    return null;
  }

  static Bug? bug(TileType type) {
    if (0.9.roll) return null;
    BugType? bugType = Generate.bugType(type);
    if (bugType == null) return null;
    return Bug.create(bugType);
  }

  static BugType? bugType(TileType type) {
    // ignore: prefer_function_declarations_over_variables
    switch (type) {
      case TileType.lightLeaf:
        return BugType.wasp;
      case TileType.bark:
      case TileType.darkLeaf:
        return [
          BugType.termite,
          BugType.ant,
          BugType.antLarva,
          BugType.antLarva,
        ].choice;
      case TileType.hardwood2:
      case TileType.softwood2:
        return [BugType.ant, BugType.termite].choice;
      case TileType.softwood1:
      case TileType.hardwood1:
        return [BugType.ant, BugType.bigTermite].choice;
      case TileType.dirt:
        return [
          BugType.grub,
          BugType.wasp,
          BugType.termite,
          BugType.bigTermite,
          BugType.antQueen,
        ].choice;
      case TileType.goal:
        return null;
    }
  }

  static final int _idSize = 10000000;
  static String get id => (Random().nextInt(_idSize) + _idSize).toString();
}
