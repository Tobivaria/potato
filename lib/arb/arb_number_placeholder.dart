import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/arb/arb_definition.dart';

import 'package:potato/arb/arb_placerholder.dart';

enum ArbNumberFormat {
  compact,
  compactCurrency,
  compactSimpleCurrency,
  compactLong,
  currency,
  decimalPattern,
  decimalPercentPattern,
  percentPattern,
  scientificPattern,
  simpleCurrency
}

@immutable
class ArbNumberPlaceholder extends ArbPlaceholder {
  final ArbNumberFormat format;

  const ArbNumberPlaceholder({required String id, required ArbType type, required this.format, String? example})
      : assert(type == ArbType.DateTime || type == ArbType.String),
        super(id: id, type: type, example: example);

  @override
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> out = super.toMap();
    out['format'] = format.name;
    return out;
  }

  // TODO
  // factory ArbNumberPlaceholder.fromMap(Map<String, dynamic> map) {
  //   final ArbPlaceholder arb = ArbPlaceholder.fromMap(map);
  //   return ArbNumberPlaceholder(
  //     ArbNumberFormat.values.byName(map['format'] as String)
  //   );
  // }

  @override
  String toString() => 'ArbNumberPlaceholder(numberFormat: $format)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArbNumberPlaceholder && other.format == format;
  }

  @override
  int get hashCode => format.hashCode;
}
