import 'dart:developer';

import 'package:quail_57/gameplay/domain/entity/bug.dart';
import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/gameplay/domain/game/queue.dart';
import 'package:quail_57/gameplay/domain/geometry/bitri.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/entity/tile_type.dart';
import 'package:quail_57/gameplay/domain/game/tree.dart';
import 'package:quail_57/shared/data/generate.dart';
import 'package:quail_57/shared/domain/report_boxer.dart';
import 'package:quail_57/shared/ui/pair_first_second.dart';
import 'package:quail_57/shared/ui/string_id_format.dart';

class Game {
  final Tree previousTree;
  // final Coordinate prevoiusYouCoordinate; // TODO add this! It will fix the viewport bugs
  final Tree currentTree;
  final int index;
  final Coordinate youCoordinate;
  final TurnQueue queue;

  Game({
    required this.index,
    required this.previousTree,
    required this.currentTree,
    required this.youCoordinate,
    required this.queue,
  });

  static Game initial(BugType type) {
    Coordinate youCoordinate = Generate.coordinate(3, last: BiTri.middle);
    Tree tree = Tree.initial(youCoordinate, type);
    return Game(
      index: 0,
      previousTree: tree,
      currentTree: tree,
      youCoordinate: youCoordinate,
      queue: TurnQueue(tree.allBugIds()),
    );
  }

  bool get youLost => false;
  bool get youWon => currentTree[youCoordinate].type == TileType.goal;
  bool get isEndgame => youWon || youLost;

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
      youCoordinate: youCoordinate.rebase(byDepth)!,
      previousTree: previousTree.rebase(byDepth),
      currentTree: currentTree.rebase(byDepth),
      index: index,
      queue: queue,
    );
  }

  Game _progress(
    Tree nextTree,
    TurnQueue nextQueue, {
    Coordinate? nextYouCoordinate,
  }) {
    logReport();
    nextYouCoordinate ??= youCoordinate;
    return Game(
      currentTree: nextTree.removeFloors(root),
      previousTree: currentTree,
      youCoordinate: nextYouCoordinate,
      index: index + 1,
      queue: nextQueue,
    ).rebased;
  }

  Game afterNextTurn() {
    (String?, TurnQueue) nextPair = queue.next(currentTree.allBugIds());
    String? bugId = nextPair.first;
    TurnQueue nextQueue = nextPair.second;
    Coordinate? mover = currentTree.findBug(where: (bug) => bug.id == bugId);
    if (mover == null) return _progress(currentTree, nextQueue);
    return _progress(
      currentTree.preparedForTurn.withMove(
        mover,
        Generate.step(currentTree, mover),
      ),
      nextQueue,
    );
  }

  Game skipUntilYourTurn() {
    Game ret = this;
    for (int i = 0; i < 1000; i++) {
      String? moverId = ret.queue.nextMoverId;
      if (moverId == null) throw AssertionError("No movers?");
      if (moverId == you?.id) return ret;
      ret = ret.afterNextTurn();
    }
    throw UnimplementedError(
      "Should never fall through (or maybe you need to increase the cap?)",
    );
  }

  Game afterYourNextTurn(Coordinate to) {
    Game game = skipUntilYourTurn();
    Tree nextTree = game.currentTree.preparedForTurn.withMove(
      game.youCoordinate,
      to,
    );

    (String?, TurnQueue) pair = game.queue.next(game.currentTree.allBugIds());

    return _progress(
      nextTree,
      pair.second,
      nextYouCoordinate: nextTree.findBug(where: (bug) => bug.isYou),
    );
  }

  // TODO move ordering system. Who Goes In What Order?
  Coordinate? get nextMoverCoordinate =>
      currentTree.allBugCoordinates().firstOrNull;
  bool get isYourTurn {
    String? yourId = currentTree[youCoordinate].bug?.id;
    return queue.nextMoverId == yourId;
  }

  Coordinate get root => youCoordinate.outof;
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
        "Next Mover: ${queue.queue.firstOrNull.idFormat}",
        "Left In Queue: ${queue.queue.length}",
      ].join("\n"),
    );
    log(report);
  }
}
