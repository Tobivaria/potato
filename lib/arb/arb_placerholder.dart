import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/arb/arb_definition.dart';

@immutable
class ArbPlaceholder {
  final String id;
  final ArbType type;
  final String? example;

  const ArbPlaceholder({required this.id, required this.type, this.example});

  factory ArbPlaceholder.fromMap(MapEntry<String, dynamic> map) {
    final entries = map.value as Map<String, dynamic>;

    return ArbPlaceholder(
      id: map.key,
      type: ArbType.values.byName(entries['type'] as String),
      example: entries['example'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    final entries = {
      'type': type.name,
    };

    if (example != null) {
      entries['example'] = example!;
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
        other.example == example;
  }

  @override
  int get hashCode {
    return id.hashCode ^ type.hashCode ^ example.hashCode;
  }

  @override
  String toString() =>
      'ArbPlaceholder(id: $id, type: $type, example: $example)';
}
