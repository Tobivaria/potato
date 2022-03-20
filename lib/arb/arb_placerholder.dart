import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/arb/arb_definition.dart';

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

  factory ArbPlaceholder.fromMap(MapEntry<String, dynamic> map) {
    final entries = map.value as Map<String, dynamic>;

    return ArbPlaceholder(
        id: map.key,
        type: ArbType.values.byName(entries['type'] as String),
        example: entries['example'] as String?,
        numberFormat: entries['format'] == null ? null : ArbNumberFormat.values.byName(entries['format'] as String));
  }

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
