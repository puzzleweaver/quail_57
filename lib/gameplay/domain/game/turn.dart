import 'package:quail_57/gameplay/domain/entity/bug.dart';
import 'package:quail_57/gameplay/domain/game/game.dart';
import 'package:quail_57/gameplay/domain/game/tree.dart';
import 'package:quail_57/gameplay/domain/geometry/coordinate.dart';
import 'package:quail_57/shared/data/generate.dart';

class Turn {
  final Tree nextTree;
  final String? activityDescription;
  final Coordinate? nextYouCoordinate;

  Turn({
    required this.nextTree,
    required this.activityDescription,
    required this.nextYouCoordinate,
  });

  factory Turn.yours({
    required Game game,
    required Coordinate to,
    required String? activityDescription,
  }) {
    Tree nextTree = game.currentTree.withMove(game.youCoordinate, to);
    return Turn(
      nextTree: nextTree,
      activityDescription: activityDescription,
      nextYouCoordinate: nextTree.findBug(where: (bug) => bug.isYou),
    );
  }

  factory Turn.bug({required Game game, required Coordinate bugCoordinate}) {
    Bug? bug = game.currentTree[bugCoordinate].bug;
    return Turn(
      nextTree: game.currentTree.withMove(
        bugCoordinate,
        Generate.step(game.currentTree, bugCoordinate),
      ),
      activityDescription: "${bug?.type.title} did a thing.",
      nextYouCoordinate: null,
    );
  }

  List<String> updatedActivityLogs(List<String> oldLogs) {
    String? description = activityDescription;
    if (description == null) return oldLogs;
    return [...oldLogs, description];
  }
}
