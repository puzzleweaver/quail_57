import 'dart:developer';

import 'package:quail_57/gameplay/domain/entity/emmy.dart';
import 'package:quail_57/gameplay/domain/entity/emmy_type.dart';
import 'package:quail_57/gameplay/domain/geometry/bitri.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/entity/entity.dart';
import 'package:quail_57/gameplay/domain/move_changes.dart';
import 'package:quail_57/gameplay/domain/space.dart';
import 'package:quail_57/gameplay/domain/space_type.dart';
import 'package:quail_57/shared/data/generate.dart';
import 'package:quail_57/shared/ui/list_choice.dart';

class Tree {
  final Map<Coordinate, Space> map;
  final int depthOffset;
  final int turns;

  Tree({required this.map, required this.depthOffset, required this.turns}) {
    map.entries.where((entry) => !entry.key.isValid).map((entry) {
      Coordinate coordinate = entry.key;
      Space? space = map[coordinate];
      if (space != null) map[coordinate] = space.withEntity(null);
      return "";
    });
    int emmyCount = allEmmies().length;
    String report = [
      "",
      "-----------------------",
      "| Thing Count: $thingCount",
      "| Emmy Density: ${(emmyCount / thingCount).toStringAsFixed(2)}",
      "| You Depth: ${whereYou?.depth}",
      "| You Length: ${whereYou?.length}",
      "| Turns So Far: $turns",
      "-----------------------",
      "",
    ].join("\n");
    log(report);
  }

  bool get youLost => whereYou == null;
  bool get youWon => this[whereYou].type == SpaceType.goal;
  bool get isEndgame => youWon || youLost;

  int get thingCount => map.length;

  static Tree initial() {
    Tree ret = Tree(
      map: {
        Generate.coordinate(3, last: BiTri.middle): Generate.space(
          0,
        ).withEntity(Emmy.create(EmmyType.all.choice, isYou: true)),
      },
      depthOffset: 0,
      turns: 0,
    );
    ret.removeFloors();
    // ret = ret.touchAll(ret.root?.outof?.outof, 4);
    return ret;
  }

  Tree touchAll(Coordinate? root, int depth) {
    if (depth <= 0 || root == null) return this;
    this[root];
    Tree ret = this;
    for (BiTri bt in BiTri.all()) {
      ret = touchAll(root.into.replaceLast(bt), depth - 1);
    }
    return ret;
  }

  Space operator [](Coordinate? where) {
    if (where == null) {
      return Space(
        hasFloor: true,
        entity: null,
        type: Generate.spaceType(where?.depth ?? 0),
      );
    }
    return map[where] ??= Generate.space(where.depth);
  }

  Tree setEntity(Coordinate? where, Entity? entity) {
    if (where == null) return this;
    return Tree(
      map: {
        ...map,
        where: (map[where] ?? Generate.space(where.depth)).withEntity(entity),
        // TODO Space.random, or Space.empty???
      },
      depthOffset: depthOffset,
      turns: turns,
    );
  }

  Coordinate? findEntity(Entity? target) {
    if (target == null) return null;
    return map.entries
        .where((entry) => entry.value.entity?.id == target.id)
        .firstOrNull
        ?.key;
  }

  Map<Coordinate, Space> _rebaseEntry(
    MapEntry<Coordinate, Space> entry,
    int byDepth,
  ) {
    Coordinate? rebased = entry.key.rebase(byDepth);
    if (rebased == null || rebased.length > 23) return {};
    return {rebased: entry.value};
  }

  Tree rebase(int byDepth) {
    return Tree(
      map: {
        for (MapEntry<Coordinate, Space> entry in map.entries)
          ..._rebaseEntry(entry, byDepth),
      },
      depthOffset: depthOffset + byDepth,
      turns: turns,
    );
  }

  int? get rebasableBy {
    Coordinate? whereYou = this.whereYou;
    if (whereYou == null) return null;
    if (whereYou.length > 20) return 5;
    if (whereYou.length < 5) return -5;
    return null;
  }

  void removeFloors() {
    Coordinate? whereYou = this.whereYou;
    void at(Coordinate? where) {
      if (where == null) return;
      map[where] = this[where].withoutFloor;
    }

    at(whereYou?.outof);
    at(whereYou?.outof?.outof);
    at(whereYou?.outof?.outof?.outof);
    at(whereYou?.outof?.outof?.outof?.outof);
  }

  void removeEntity(Coordinate where) {
    Space? space = map[where];
    if (space == null) return;
    map[where] = space.withEntity(null);
  }

  Iterable<Coordinate> allEmmies({bool includeYou = false}) => map.entries
      .where((entry) {
        if (!includeYou && entry.value.isYou) return false;
        return entry.value.isEmmy;
      })
      .map((entry) => entry.key);

  MapEntry<Coordinate, Space>? get _youEntry =>
      map.entries.where((e) => e.value.isYou).firstOrNull;
  Coordinate? get whereYou => _youEntry?.key;
  Emmy? get you {
    Entity? entity = _youEntry?.value.entity;
    if (entity is! Emmy || entity.isYou != true) return null;
    return entity;
  }

  Coordinate? get root => whereYou?.outof;

  Tree moveYouTo(Coordinate whereYouGo) {
    // stuff we can iterate on
    Tree newTree = Tree(
      map: {...map},
      depthOffset: depthOffset,
      turns: turns + 1,
    );
    void makeMove(Coordinate? from, Coordinate? to) {
      if (newTree.isMoveAllowed(from, to)) {
        newTree.map.addAll(newTree.moveChanges(from, to));
      }
    }

    // move you
    newTree.removeFloors();
    Coordinate? whereYou = this.whereYou;
    makeMove(whereYou, whereYouGo);

    // move emmies
    for (Coordinate whereEmmy in newTree.allEmmies().toList()) {
      Coordinate whereEmmyGo = whereEmmy.randomStep;
      if (!whereEmmy.isValid || !whereEmmyGo.isValid) {
        newTree.removeEntity(whereEmmy);
      }
      makeMove(whereEmmy, whereEmmyGo);
    }

    if (you?.age == null) newTree = newTree.setEntity(whereYou, null);

    return newTree;
  }

  Map<Coordinate, Space> moveChanges(Coordinate? from, Coordinate? to) {
    if (from == null || to == null) return {};
    return MoveChanges(this, from, to).asMap;
  }

  /// check if there is a wall
  bool isMoveAllowed(Coordinate? from, Coordinate? to) {
    if (from == null || to == null) return false;
    if (from.into == to && this[from].hasFloor) return false;
    return true;
  }

  Tree setYou(EmmyType type) {
    return setEntity(whereYou, you?.withEmmyType(type));
  }
}
