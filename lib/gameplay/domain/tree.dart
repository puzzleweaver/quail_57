import 'dart:developer';

import 'package:quail_57/gameplay/domain/entity/emmy.dart';
import 'package:quail_57/gameplay/domain/entity/emmy_type.dart';
import 'package:quail_57/gameplay/domain/geometry/bitri.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/move_changes.dart';
import 'package:quail_57/gameplay/domain/tile.dart';
import 'package:quail_57/gameplay/domain/tile_type.dart';
import 'package:quail_57/shared/data/generate.dart';
import 'package:quail_57/shared/ui/list_choice.dart';

class Tree {
  final Map<Coordinate, Tile> map;
  final int depthOffset;
  final int turns;
  final Coordinate whereYou;

  Tree({
    required this.map,
    required this.whereYou,
    required this.depthOffset,
    required this.turns,
  }) {
    int emmyCount = whereEmmies().length;
    String report = [
      "",
      "-----------------------",
      "| Thing Count: $thingCount",
      "| Emmy Density: ${(emmyCount / thingCount).toStringAsFixed(2)}",
      "| You Depth: ${whereYou.depth}",
      "| You Length: ${whereYou.length}",
      "| Turns So Far: $turns",
      "-----------------------",
      "",
    ].join("\n");
    log(report);
  }

  bool get youLost => false;
  bool get youWon => this[whereYou].type == TileType.goal;
  bool get isEndgame => youWon || youLost;

  int get thingCount => map.length;

  static Tree initial(EmmyType emmyType) {
    Coordinate coordinate = Generate.coordinate(3, last: BiTri.middle);
    Tree ret = Tree(map: {}, whereYou: coordinate, depthOffset: 0, turns: 0);
    ret = ret.setTile(
      coordinate,
      ret[coordinate].withEmmy(Emmy.create(emmyType, isYou: true)),
    );
    ret = ret.removeFloors();
    return ret;
  }

  Tree setTile(Coordinate coordinate, Tile tile) {
    return Tree(
      map: {...map, coordinate: tile},
      whereYou: whereYou,
      depthOffset: depthOffset,
      turns: turns,
    );
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

  Tile operator [](Coordinate? where) {
    if (where == null) {
      return Tile.empty(where?.depth ?? 0);
    }
    return map[where] ??= Generate.tile(where.depth);
  }

  Coordinate? findEmmy(Emmy? target) {
    if (target == null) return null;
    return map.entries
        .where((entry) => entry.value.emmy?.id == target.id)
        .firstOrNull
        ?.key;
  }

  Map<Coordinate, Tile> _rebaseEntry(
    MapEntry<Coordinate, Tile> entry,
    int byDepth,
  ) {
    Coordinate? rebased = entry.key.rebase(byDepth);
    if (rebased == null || rebased.length > 23) return {};
    return {rebased: entry.value};
  }

  Tree rebase(int byDepth) {
    return Tree(
      map: {
        for (MapEntry<Coordinate, Tile> entry in map.entries)
          ..._rebaseEntry(entry, byDepth),
      },
      depthOffset: depthOffset + byDepth,
      turns: turns,
      whereYou: whereYou.rebase(byDepth) ?? Coordinate.zero,
    );
  }

  int? get rebasableBy {
    Coordinate? whereYou = this.whereYou;
    if (whereYou.length > 20) return 5;
    if (whereYou.length < 5) return -5;
    return null;
  }

  Tree removeFloors() {
    Coordinate? whereYou = this.whereYou;
    Tree ret = this;
    void at(Coordinate? where) {
      if (where == null) return;
      ret = ret.setTile(where, ret[where].withoutFloor);
    }

    at(whereYou.outof);
    at(whereYou.outof.outof);
    at(whereYou.outof.outof.outof);
    at(whereYou.outof.outof.outof.outof);

    return ret;
  }

  Iterable<Coordinate> whereEmmies({bool includeYou = false}) => map.entries
      .where((entry) {
        if (!includeYou && entry.value.hasYou) return false;
        return entry.value.hasEmmy;
      })
      .map((entry) => entry.key);

  Emmy? get you {
    Emmy? entity = this[whereYou].emmy;
    if (entity == null || !entity.isYou) return null;
    return entity;
  }

  Coordinate? get root => whereYou.outof;

  Coordinate randomStepFrom(Coordinate coordinate) {
    return [...coordinate.adjacents, coordinate.into, coordinate.outof]
        .whereType<Coordinate>()
        .where((step) => isMoveAllowed(coordinate, step))
        .toList()
        .choice;
  }

  Tree moveYouTo(Coordinate whereYouGo) {
    // stuff we can iterate on
    Tree newTree = Tree(
      map: {...map},
      depthOffset: depthOffset,
      turns: turns + 1,
      whereYou: whereYouGo,
    );
    void makeMove(Coordinate? from, Coordinate? to) {
      if (newTree.isMoveAllowed(from, to)) {
        Map<Coordinate, Tile> changes = newTree.moveChanges(from, to);
        for (final entry in changes.entries) {
          newTree = newTree.setTile(entry.key, entry.value);
        }
      }
    }

    // move you
    newTree = newTree.removeFloors();
    Coordinate? whereYou = this.whereYou;
    makeMove(whereYou, whereYouGo);

    // move emmies
    // for (Coordinate whereEmmy in newTree.allEmmies().toList()) {
    //   Coordinate whereEmmyGo = randomStepFrom(whereEmmy);
    //   makeMove(whereEmmy, whereEmmyGo);
    // }

    return newTree;
  }

  Map<Coordinate, Tile> moveChanges(Coordinate? from, Coordinate? to) {
    if (from == null || to == null) return {};
    return MoveChanges(this, from, to).asMap;
  }

  /// check if there is a wall
  bool isMoveAllowed(Coordinate? from, Coordinate? to) {
    if (from == null || to == null) return false;
    if (from.into == to && this[from].hasFloor) return false;
    return true;
  }
}
