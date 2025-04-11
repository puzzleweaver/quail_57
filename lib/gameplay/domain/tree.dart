import 'package:quail_57/gameplay/domain/entity/bug.dart';
import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/move_changes.dart';
import 'package:quail_57/gameplay/domain/tile.dart';
import 'package:quail_57/shared/data/generate.dart';
import 'package:quail_57/shared/ui/list_choice.dart';

class Tree {
  final Map<Coordinate, Tile> map;
  final int depthOffset;

  Tree({required this.map, required this.depthOffset});

  int get thingCount => map.length;

  static Tree initial(Coordinate coordinate, BugType bugType) {
    Tree ret = Tree(map: {}, depthOffset: 0);
    ret = ret.setTile(
      coordinate,
      ret[coordinate].withBug(Bug.create(bugType, isYou: true)),
    );
    ret = ret.removeFloors(coordinate);
    return ret;
  }

  Tree get preparedForTurn {
    return withMovesCleared;
  }

  Tree get withMovesCleared {
    Tree ret = this;
    for (Coordinate whereBug in whereBugs()) {
      ret = ret.setTile(whereBug, this[whereBug].withMovesCleared);
    }
    return ret;
  }

  Tree setTile(Coordinate coordinate, Tile tile) {
    return Tree(map: {...map, coordinate: tile}, depthOffset: depthOffset);
  }

  Tile operator [](Coordinate? where) {
    if (where == null) {
      return Tile.empty(where?.depth ?? 0);
    }
    return map[where] ??= Generate.tile(where.depth);
  }

  Coordinate? findBug(bool Function(Bug) condition) {
    return map.entries
        .where((entry) {
          Bug? bug = entry.value.bug;
          if (bug == null) return false;
          return condition(bug);
        })
        .firstOrNull
        ?.key;
  }

  Map<Coordinate, Tile> _rebaseEntry(
    MapEntry<Coordinate, Tile> entry,
    int byDepth,
  ) {
    Coordinate? rebased = entry.key.rebase(byDepth);
    if (rebased == null || rebased.length > 23) return {};
    return {rebased: entry.value.rebase(byDepth)};
  }

  Tree rebase(int byDepth) {
    return Tree(
      map: {
        for (MapEntry<Coordinate, Tile> entry in map.entries)
          ..._rebaseEntry(entry, byDepth),
      },
      depthOffset: depthOffset + byDepth,
    );
  }

  Tree removeFloors(Coordinate coordinate) {
    Tree ret = this;
    for (int i = 0; i < 3; i++) {
      coordinate = coordinate.outof;
      ret = ret.setTile(coordinate, ret[coordinate].withoutFloor);
    }
    return ret;
  }

  Iterable<Coordinate> whereBugs({bool includeYou = false}) => map.entries
      .where((entry) {
        if (!includeYou && entry.value.hasYou) return false;
        return entry.value.hasBug;
      })
      .map((entry) => entry.key);

  Coordinate randomStepFrom(Coordinate coordinate) {
    return [...coordinate.adjacents, coordinate.into, coordinate.outof]
        .whereType<Coordinate>()
        .where((step) => isMoveAllowed(coordinate, step))
        .toList()
        .choice;
  }

  Tree withMove(Coordinate? from, Coordinate? to) {
    Tree ret = this;
    if (ret.isMoveAllowed(from, to)) {
      Map<Coordinate, Tile> changes = ret.moveChanges(from, to);
      for (final entry in changes.entries) {
        ret = ret.setTile(entry.key, entry.value);
      }
    }
    return ret;
  }

  Map<Coordinate, Tile> moveChanges(Coordinate? from, Coordinate? to) {
    if (from == null || to == null) return {};
    return MoveChanges(tree: this, from: from, to: to).getDeltas;
  }

  /// check if there is a wall
  bool isMoveAllowed(Coordinate? from, Coordinate? to) {
    if (from == null || to == null) return false;
    if (from.into == to && this[from].hasFloor) return false;
    return true;
  }
}
