import 'dart:math';

import 'package:quail_57/math/entity.dart';

/// A thing that might be placed at a coordinate.
class Space {
  final Entity? entity;
  final bool hasFloor;

  Space({required this.hasFloor, required this.entity});

  static Space get empty => Space(entity: null, hasFloor: false);
  static Space get wall => Space(entity: null, hasFloor: true);

  static Space get random => Space(
    entity: Random().nextBool() ? null : Entity.random,
    hasFloor: Random().nextDouble() < 0.5,
  );

  Space withEntity(Entity? entity) => Space(entity: entity, hasFloor: hasFloor);

  bool get isEmpty => entity == null;
  bool get isYou => entity?.isYou ?? false;
  bool get isEmmy => entity?.isEmmy ?? false;
  bool get isFruit => entity?.isFruit ?? false;
  bool get moves => entity?.moves ?? false;
}
