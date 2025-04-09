import 'package:quail_57/shared/ui/int_in_range.dart';

extension RangePick<T> on Map<(int?, int?), T> {
  T rangePick(int depth, T fallback) {
    for (final entry in entries) {
      if (entry.key.includes(depth)) return entry.value;
    }
    return fallback;
  }
}
