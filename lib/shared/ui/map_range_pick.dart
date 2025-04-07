import 'package:quail_57/shared/ui/int_in_range.dart';
import 'package:quail_57/shared/ui/list_choice.dart';

extension RangePick<T> on Map<(int?, int?), List<T>> {
  T rangePick(int depth, T fallback) {
    for (final entry in entries) {
      if (entry.key.includes(depth)) return entry.value.choice;
    }
    return fallback;
  }
}
