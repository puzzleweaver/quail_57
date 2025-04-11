import 'dart:developer';

import 'package:quail_57/gameplay/domain/entity/bug.dart';
import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/gameplay/domain/geometry/bitri.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/tile_type.dart';
import 'package:quail_57/gameplay/domain/tree.dart';
import 'package:quail_57/shared/data/generate.dart';

class Turn {
  final Tree previousTree;
  // final Coordinate previousWhereYou; // TODO add this! Itd clean stuff up
  final Tree currentTree;
  final int index;
  final Coordinate whereYou;

  Turn({
    required this.previousTree,
    required this.currentTree,
    required this.index,
    required this.whereYou,
  });

  static Turn initial(BugType type) {
    Coordinate whereYou = Generate.coordinate(3, last: BiTri.middle);
    Tree tree = Tree.initial(whereYou, type);
    return Turn(
      index: 0,
      previousTree: tree,
      currentTree: tree,
      whereYou: whereYou,
    );
  }

  bool get youLost => false;
  bool get youWon => currentTree[whereYou].type == TileType.goal;
  bool get isEndgame => youWon || youLost;

  int? get _rebaseAmount {
    Coordinate? whereYou = this.whereYou;
    if (whereYou.length > 20) return 5;
    if (whereYou.length < 5) return -5;
    return null;
  }

  Turn get rebased {
    int? byDepth = _rebaseAmount;
    print("${whereYou.length}, by ${byDepth}");
    if (byDepth == null) return this;
    return Turn(
      whereYou: whereYou.rebase(byDepth)!,
      previousTree: previousTree.rebase(byDepth),
      currentTree: currentTree.rebase(byDepth),
      index: index,
    );
  }

  Turn _progress(Tree nextTree, {Coordinate? nextWhereYou}) {
    nextWhereYou ??= whereYou;
    return Turn(
      currentTree: nextTree,
      previousTree: currentTree,
      whereYou: nextWhereYou,
      index: index + 1,
    ).rebased;
  }

  Turn afterNextTurn() {
    Coordinate mover = nextMover!;
    Coordinate to = currentTree.randomStepFrom(mover);
    return _progress(currentTree.preparedForTurn.withMove(mover, to));
  }

  Turn afterYourNextTurn(Coordinate to) {
    Tree nextTree = currentTree.preparedForTurn.withMove(whereYou, to);
    return _progress(
      nextTree,
      nextWhereYou: nextTree.findBug((bug) => bug.isYou),
    );
  }

  // TODO speed system? countdowns?
  Coordinate? get nextMover => currentTree.whereBugs().firstOrNull;
  bool get isYourTurn => false;

  Bug? get you {
    Bug? entity = currentTree[whereYou].bug;
    if (entity == null || !entity.isYou) return null;
    return entity;
  }

  Coordinate get root => whereYou.outof;

  void logReport() {
    int bugCount = currentTree.whereBugs().length;
    int entryCount = currentTree.map.length;
    String report = [
      "",
      "-----------------------",
      "| Thing Count: $entryCount",
      "| Bug Density: ${(bugCount / entryCount).toStringAsFixed(2)}",
      "| You Depth: ${whereYou.depth}",
      "| You Length: ${whereYou.length}",
      "| Turns So Far: $index",
      "-----------------------",
      "",
    ].join("\n");
    log(report);
  }
}
