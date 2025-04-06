import 'package:quail_57/math/coordinate.dart';
import 'package:quail_57/math/entity.dart';
import 'package:quail_57/math/space.dart';

class Tree {
  final Map<Coordinate, Space> map;

  Tree(this.map);

  int get length => map.length;

  static Tree initial() {
    return Tree({
      Coordinate.zero: Space.empty,
      Coordinate.zero.into: Space.empty,
    }).setEntity(Coordinate.zero.into, Entity.you);
  }

  Space operator [](Coordinate? where) {
    if (where == null) return Space.empty;
    return map[where] ??= Space.random;
  }

  Tree setEntity(Coordinate? where, Entity? entity) {
    if (where == null) return this;
    return Tree({
      ...map,
      where: (map[where] ?? Space.random).withEntity(entity),
      // TODO Space.random, or Space.empty???
    });
  }

  Coordinate? findEntity(Entity? target) {
    if (target == null) return null;
    return map.entries
        .where((entry) => entry.value.entity?.id == target.id)
        .firstOrNull
        ?.key;
  }

  // add details from root to depth layers after
  Tree loadMore(Coordinate root, int depth) {
    return Tree({...map});
  }

  Iterable<Coordinate> get allEmmies => map.entries
      .where((entry) => entry.value.entity?.isEmmy == true)
      .map((entry) => entry.key);

  MapEntry<Coordinate, Space>? get _youEntry =>
      map.entries.where((e) => e.value.isYou).firstOrNull;
  Coordinate? get whereYou => _youEntry?.key;
  Entity? get you => _youEntry?.value.entity;

  Coordinate? get root => whereYou?.outof;
  Tree moveYouTo(Coordinate newPlace) {
    Coordinate? whereYou = this.whereYou;
    if (whereYou == null) return this;
    return Tree({
      ...map,
      for (Coordinate whereEmmy in allEmmies.toList())
        ..._moveChanges(whereEmmy, whereEmmy.randomStep),
      ..._moveChanges(whereYou, newPlace),
    });
  }

  bool isMoveAllowed(Coordinate? from, Coordinate? to) {
    if (from == null || to == null) return false;
    if (to == from.into && this[from].hasFloor) return false;
    // TODO check for collisions? hmm...
    return true;
  }

  Map<Coordinate, Space> _moveChanges(Coordinate from, Coordinate to) {
    Space fromSpace = this[from];
    Space toSpace = this[to];
    Entity? mover = fromSpace.entity;
    if (mover == null || !isMoveAllowed(from, to)) return {};
    return {from: fromSpace.withEntity(null), to: toSpace.withEntity(mover)};
  }
}
