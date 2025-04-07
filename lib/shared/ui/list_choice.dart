import 'dart:math';

extension ListChoice<T> on List<T> {
  T get choice => this[Random().nextInt(length)];
  T weightedChoice(Map<T, int> weights) {
    int weightOf(T t) => weights[t] ?? 0;
    int total = fold(0, (soFar, t) => soFar + weightOf(t));
    int choice = Random().nextInt(total);
    for (T t in this) {
      choice -= weightOf(t);
      if (choice <= 0) return t;
    }
    print("UH OH");
    return first;
  }
}
