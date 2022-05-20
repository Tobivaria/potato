import 'package:fluent_ui/fluent_ui.dart';

@immutable
class Usage {
  final int current;
  final int max;

  const Usage(this.current, this.max);

  /// Returns the already used percentage
  double get usedPercentage => current / max * 100;
}
