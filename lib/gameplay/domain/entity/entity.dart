enum EntityType { you, emmy, fruit }

abstract class Entity {
  final EntityType type;
  final String id;

  Entity({required this.id, required this.type});

  // static Entity? get random {
  //   double choice = Random().nextDouble() * 2;
  //   if (choice < 1) return Emmy(emmyType: EmmyType.random);
  //   return Fruit.random;
  // }

  bool get isYou => type == EntityType.you;
  bool get isEmmy => type == EntityType.emmy;
  bool get isFruit => type == EntityType.fruit;

  Entity? get age => this;

  @override
  String toString() => "$type ${id.substring(0, 8)}";
}
