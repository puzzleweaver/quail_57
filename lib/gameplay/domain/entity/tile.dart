import 'package:quail_57/gameplay/domain/entity/bug.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/game/move.dart';
import 'package:quail_57/gameplay/domain/entity/tile_type.dart';
import 'package:quail_57/shared/data/generate.dart';

/// A thing that might be placed at a coordinate.
class Tile {
  final Bug? bug;
  final Fruit? fruit;
  final bool hasFloor;
  final TileType type;

  Tile({
    required this.hasFloor,
    required this.bug,
    required this.fruit,
    required this.type,
  });

  static Tile empty(int depth) => Tile(
    bug: null,
    fruit: null,
    hasFloor: false,
    type: Generate.spaceType(depth),
  );

  Tile withBug(Bug? bug) =>
      Tile(bug: bug, hasFloor: hasFloor, type: type, fruit: fruit);
  Tile withFruit(Fruit? fruit) =>
      Tile(bug: bug, hasFloor: hasFloor, type: type, fruit: fruit);

  Tile rebase(int byDepth) => Tile(
    hasFloor: hasFloor,
    bug: bug?.rebase(byDepth),
    fruit: fruit,
    type: type,
  );

  Tile get withoutFloor =>
      Tile(bug: bug, fruit: null, hasFloor: false, type: type);

  Tile get withMovesCleared => withBug(bug?.withMove(Move.none));

  bool get isEmpty => bug == null && fruit == null;
  bool get hasYou => bug?.isYou ?? false;
  bool get hasBug => bug != null;
  bool get hasFruit => fruit != null;
}
