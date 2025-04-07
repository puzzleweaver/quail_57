import 'package:quail_57/gameplay/domain/entity/entity.dart';
import 'package:quail_57/gameplay/domain/space_type.dart';
import 'package:quail_57/shared/data/generate.dart';

/// A thing that might be placed at a coordinate.
class Space {
  final Entity? entity;
  final bool hasFloor;
  final SpaceType type;

  Space({required this.hasFloor, required this.entity, required this.type});

  static Space empty(int depth) =>
      Space(entity: null, hasFloor: false, type: Generate.spaceType(depth));

  Space withEntity(Entity? entity) =>
      Space(entity: entity, hasFloor: hasFloor, type: type);
  Space get withoutFloor => Space(entity: entity, hasFloor: false, type: type);

  bool get isEmpty => entity == null;
  bool get isYou => entity?.isYou ?? false;
  bool get isEmmy => entity?.isEmmy ?? false;
  bool get isFruit => entity?.isFruit ?? false;
  bool get moves => entity?.moves ?? false;

  bool get isOccupied => entity?.isOccupied ?? false;
}
