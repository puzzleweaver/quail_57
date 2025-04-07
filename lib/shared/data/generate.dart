import 'dart:math';

import 'package:quail_57/gameplay/domain/math/bitri.dart';
import 'package:quail_57/gameplay/domain/entity/emmy.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/math/coordinate.dart';
import 'package:quail_57/gameplay/domain/space.dart';
import 'package:quail_57/gameplay/domain/space_type.dart';
import 'package:quail_57/gameplay/domain/math/tri.dart';
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

  static SpaceType spaceType(int depth) {
    List<SpaceType> darkLeafZone = [SpaceType.darkLeaf],
        lightLeafZone = [SpaceType.lightLeaf],
        barkZone = [SpaceType.bark],
        softwoodZone = [SpaceType.softwood1, SpaceType.softwood2],
        hardwoodZone = [SpaceType.hardwood1, SpaceType.hardwood2],
        dirtZone = [SpaceType.dirt];
    return {
      (null, -6): lightLeafZone,
      (-6, -4): lightLeafZone + darkLeafZone,
      (-4, 0): darkLeafZone,
      (0, 3): darkLeafZone + barkZone,
      (3, 7): barkZone,
      (7, 12): barkZone + hardwoodZone,
      (12, 14): hardwoodZone,
      (14, 20): hardwoodZone + softwoodZone,
      (20, 25): softwoodZone,
      (25, 28): softwoodZone + dirtZone,
      (28, null): dirtZone,
    }.rangePick(depth, SpaceType.dirt);
  }

  static Space space(int depth) {
    return Space(
      entity: [fruit(depth), emmy(depth), null].choice,
      hasFloor: Random().nextDouble() < 0.5,
      type: spaceType(depth),
    );
  }

  static Fruit fruit(int depth) {
    return Fruit(fruitType: FruitType.all.choice);
  }

  static Emmy emmy(int depth) {
    return Emmy(emmyType: EmmyType.all.choice);
  }
}
