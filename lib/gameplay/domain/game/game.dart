import 'dart:developer';

import 'package:quail_57/gameplay/domain/entity/bug.dart';
import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/gameplay/domain/game/turn_queue.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/entity/tile_type.dart';
import 'package:quail_57/gameplay/domain/game/tree.dart';
import 'package:quail_57/shared/data/generate.dart';
import 'package:quail_57/shared/domain/report_boxer.dart';
import 'package:quail_57/shared/ui/string_id_format.dart';

class Game {
  final Tree previousTree;
  final Tree currentTree;
  final int index;
  final Coordinate youCoordinate;
  final Coordinate previousYouCoordinate;
  final TurnQueue queue;

  Game({
    required this.index,
    required this.previousTree,
    required this.currentTree,
    required this.previousYouCoordinate,
    required this.youCoordinate,
    required this.queue,
  });

  static Game initial(BugType type) {
    Coordinate youCoordinate = Coordinate.zero.into.into.into;
    Tree tree = Tree.initial(youCoordinate, type);
    return Game(
      index: 0,
      previousTree: tree,
      currentTree: tree,
      previousYouCoordinate: youCoordinate,
      youCoordinate: youCoordinate,
      queue: TurnQueue(tree.allBugIds()),
    );
  }

  bool get youLost => false;
  bool get youWon => currentTree[youCoordinate].type == TileType.goal;
  bool get isEndgame => youWon || youLost;
  String? get nextMoverId => queue.nextMoverId;

  int? get _rebaseAmount {
    Coordinate? youCoordinate = this.youCoordinate;
    if (youCoordinate.length > 20) return 5;
    if (youCoordinate.length < 5) return -5;
    return null;
  }

  Game get rebased {
    int? byDepth = _rebaseAmount;
    if (byDepth == null) return this;
    return Game(
      previousYouCoordinate: previousYouCoordinate.rebase(byDepth)!,
      youCoordinate: youCoordinate.rebase(byDepth)!,
      previousTree: previousTree.rebase(byDepth),
      currentTree: currentTree.rebase(byDepth),
      index: index,
      queue: queue,
    );
  }

  Game _advanceTurn(Tree nextTree, {Coordinate? nextYouCoordinate}) {
    nextYouCoordinate ??= youCoordinate;

    TurnQueue nextQueue = queue.nextQueue(nextTree.allBugIds());

    logReport();
    return Game(
      currentTree: nextTree.removeFloors(root),
      previousTree: currentTree,
      previousYouCoordinate: youCoordinate,
      youCoordinate: nextYouCoordinate,
      index: index + 1,
      queue: nextQueue,
    ).rebased;
  }

  /// advance one turn without changing anything.
  Game _skipTurn() {
    return _advanceTurn(currentTree);
  }

  /// Randomly move the next mover
  Game doBugTurn() {
    assert(nextMoverId != you?.id);
    Coordinate? mover = currentTree.findBug(
      where: (bug) => bug.id == nextMoverId,
    );
    //
    if (mover == null) return _skipTurn();
    return _advanceTurn(
      currentTree.preparedForTurn.withMove(
        mover,
        Generate.step(currentTree, mover),
      ),
    );
  }

  Game doYourTurn(Coordinate to) {
    Game game = doTurnsUntil((game) => game.nextMoverId == you?.id);
    Tree nextTree = game.currentTree.preparedForTurn.withMove(
      game.youCoordinate,
      to,
    );

    return _advanceTurn(
      nextTree,
      nextYouCoordinate: nextTree.findBug(where: (bug) => bug.isYou),
    );
  }

  Game doTurnsUntil(bool Function(Game game) until) {
    Game ret = this;
    for (int i = 0; i < 1000; i++) {
      if (until(ret)) return ret;
      ret = ret.doBugTurn();
    }
    throw UnimplementedError(
      "Should never fall through (or maybe you need to increase the cap?)",
    );
  }

  Game skipTurnsUntil(bool Function(Game game) until) {
    Game ret = this;
    for (int i = 0; i < 1000; i++) {
      if (until(ret)) return ret;
      ret = ret._skipTurn();
    }
    throw UnimplementedError(
      "Should never fall through (or maybe you need to increase the cap?)",
    );
  }

  bool get isYourTurn {
    String? yourId = currentTree[youCoordinate].bug?.id;
    return nextMoverId == yourId;
  }

  Coordinate get root => youCoordinate.outof;
  Coordinate get previousRoot => previousYouCoordinate.outof;

  Bug? get you {
    Bug? entity = currentTree[youCoordinate].bug;
    if (entity == null || !entity.isYou) return null;
    return entity;
  }

  void logReport() {
    int bugCount = currentTree.allBugCoordinates().length;
    int entryCount = currentTree.map.length;
    String report = ReportBoxer.format(
      [
        "Thing Count: $entryCount",
        "Bug Count: $bugCount",
        "You Depth: ${youCoordinate.depth}",
        "You Length: ${youCoordinate.length}",
        "Turns So Far: $index",
        "Next Mover: ${queue.moverIds.firstOrNull.idFormat}",
        "Left In Queue: ${queue.moverIds.length}",
      ].join("\n"),
    );
    log(report);
  }
}
