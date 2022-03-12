import 'package:fluent_ui/fluent_ui.dart';

import 'arb_definition.dart';

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

// TODO "optionalParameters": {
//         "decimalDigits": 2
//         }

@immutable
class ArbPlaceholder {
  final String id;
  final ArbType type;
  final String? example;
  final ArbNumberFormat? numberFormat;

  const ArbPlaceholder({required this.id, required this.type, this.example, this.numberFormat});

  Map<String, dynamic> toMap() {
    var entries = {
      'type': type.name,
    };

    if (example != null) {
      entries['example'] = example!;
    }

    if (numberFormat != null) {
      entries['format'] = numberFormat!.name;
    }

    return {
      id: entries,
    };
  }

  factory ArbPlaceholder.fromMap(Map<String, dynamic> map) {
    var entries = map[map.keys.first];

    return ArbPlaceholder(
        id: map.keys.first,
        type: ArbType.values.byName(entries['type']),
        example: entries['example'],
        numberFormat: entries['format'] == null ? null : ArbNumberFormat.values.byName(entries['format']));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArbPlaceholder &&
        other.id == id &&
        other.type == type &&
        other.example == example &&
        other.numberFormat == numberFormat;
  }

  @override
  int get hashCode {
    return id.hashCode ^ type.hashCode ^ example.hashCode ^ numberFormat.hashCode;
  }
}
