import 'package:quail_57/gameplay/domain/entity/emmy.dart';
import 'package:quail_57/gameplay/domain/entity/fruit.dart';
import 'package:quail_57/gameplay/domain/tile_type.dart';
import 'package:quail_57/shared/data/generate.dart';

/// A thing that might be placed at a coordinate.
class Tile {
  final Emmy? emmy;
  final Fruit? fruit;
  final bool hasFloor;
  final TileType type;

  Tile({
    required this.hasFloor,
    required this.emmy,
    required this.fruit,
    required this.type,
  });

  static Tile empty(int depth) => Tile(
    emmy: null,
    fruit: null,
    hasFloor: false,
    type: Generate.spaceType(depth),
  );

  Tile withEmmy(Emmy? emmy) =>
      Tile(emmy: emmy, hasFloor: hasFloor, type: type, fruit: fruit);
  Tile withFruit(Fruit? fruit) =>
      Tile(emmy: emmy, hasFloor: hasFloor, type: type, fruit: fruit);

  Tile get withoutFloor =>
      Tile(emmy: emmy, fruit: null, hasFloor: false, type: type);

  bool get isEmpty => emmy == null && fruit == null;
  bool get hasYou => emmy?.isYou ?? false;
  bool get hasEmmy => emmy != null;
  bool get hasFruit => fruit != null;
}
