import 'dart:math';

class Entity {
  final String type;
  final String id;

  Entity({required this.id, required this.type});

  static final int _idSize = 10000000;
  static String get _newId => (Random().nextInt(_idSize) + _idSize).toString();
  static Entity get empty => Entity(id: _newId, type: "");
  static Entity get you => empty.withType(Entities.you);
  static Entity get emmy => empty.withType(Entities.emmy);
  static Entity get fruit => empty.withType(Entities.fruit);

  Entity withType(String newType) => Entity(id: id, type: newType);

  static Entity? get random {
    double choice = Random().nextDouble() * 2;
    if (choice < 1) return emmy;
    return fruit;
  }

  bool get isYou => type == Entities.you;
  bool get isEmmy => type == Entities.emmy;
  bool get isFruit => type == Entities.fruit;
  bool get moves => isEmmy || isYou;
}

class Entities {
  static const String you = "you";
  static const String emmy = "emmy";
  static const String fruit = "fruit";
}
