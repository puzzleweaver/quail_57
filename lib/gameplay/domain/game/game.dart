import 'dart:developer';

import 'package:quail_57/gameplay/domain/entity/bug.dart';
import 'package:quail_57/gameplay/domain/entity/bug_type.dart';
import 'package:quail_57/gameplay/domain/game/turn.dart';
import 'package:quail_57/gameplay/domain/game/turn_queue.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/gameplay/domain/entity/tile_type.dart';
import 'package:quail_57/gameplay/domain/game/tree.dart';
import 'package:quail_57/shared/domain/report_boxer.dart';
import 'package:quail_57/shared/ui/string_id_format.dart';

class Game {
  final Tree previousTree;
  final Tree currentTree;
  final int index;
  final Coordinate youCoordinate;
  final Coordinate previousYouCoordinate;
  final TurnQueue queue;
  final List<String> activityLog;

  Game({
    required this.index,
    required this.previousTree,
    required this.currentTree,
    required this.previousYouCoordinate,
    required this.youCoordinate,
    required this.queue,
    required this.activityLog,
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
      activityLog: ["Welcome!"],
    );
  }

  bool get youLost => false;
  bool get youWon => currentTree[youCoordinate].type == TileType.goal;
  bool get isEndgame => youWon || youLost;
  String? get nextMoverId => queue.nextMoverId;
  Coordinate? get nextMoverCoordinate =>
      currentTree.findBug(where: (bug) => bug.id == nextMoverId);

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
      activityLog: activityLog,
    );
  }

  bool isOnScreen(Coordinate? coordinate) {
    if (coordinate == null) return false;
    return coordinate == root ||
        coordinate.outof == root ||
        coordinate.outof.outof == root;
  }

  Game advanceQueue() {
    return Game(
      index: index + 1,
      previousTree: previousTree,
      currentTree: currentTree,
      previousYouCoordinate: previousYouCoordinate,
      youCoordinate: youCoordinate,
      queue: queue.nextQueue(currentTree.allBugIds()),
      activityLog: activityLog,
    );
  }

  /// advance one turn without changing anything
  Game skipTurn() {
    return advanceQueue();
  }

  Game doTurn(Turn turn) {
    logReport();
    Game gameAfterTurn =
        Game(
          currentTree: turn.nextTree.removeFloors(root),
          previousTree: currentTree,
          previousYouCoordinate: youCoordinate,
          youCoordinate: turn.nextYouCoordinate ?? youCoordinate,
          index: index,
          queue: queue,
          activityLog: turn.updatedActivityLogs(activityLog),
        ).rebased.advanceQueue();

    return gameAfterTurn.doBugTurns(
      until: (laterGame) {
        return laterGame.isYourTurn ||
            isOnScreen(laterGame.nextMoverCoordinate);
      },
    );
  }

  /// Randomly move the next mover
  Game doBugTurn() {
    Coordinate? where = nextMoverCoordinate;
    if (where == null) return skipTurn();
    return doTurn(Turn.bug(game: this, bugCoordinate: where));
  }

  Game doYourTurn(Coordinate to) {
    // terminate ongoing animations,
    // do all bugs' turns that happen before it's your turn again
    Game game = clearAnimations().doBugTurns(until: (game) => game.isYourTurn);

    return game.doTurn(
      Turn.yours(
        game: game,
        to: to,
        activityDescription: "- You did something.",
      ),
    );
  }

  Game doBugTurns({required bool Function(Game game) until}) {
    Game ret = this;
    for (int i = 0; i < 1000; i++) {
      if (until(ret)) return ret;
      bool onScreen = !ret.isOnScreen(ret.nextMoverCoordinate);
      if (onScreen) ret = ret.doBugTurn();
      if (!onScreen) ret = ret.skipTurn();
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

  Game clearAnimations() {
    return Game(
      index: index,
      previousTree: previousTree,
      currentTree: currentTree.preparedForTurn,
      previousYouCoordinate: previousYouCoordinate,
      youCoordinate: youCoordinate,
      queue: queue,
      activityLog: activityLog,
    );
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
        "Most Recent Action: ${activityLog.lastOrNull}",
      ].join("\n"),
    );
    log(report);
  }
}
