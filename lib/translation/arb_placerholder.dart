import 'package:fluent_ui/fluent_ui.dart';

import 'arb_definition.dart';

@immutable
class ArbPlaceholder {
  final String name;
  final ArbType type;

  const ArbPlaceholder({
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': {
        'type': ArbType.String.name,
      },
    };
  }

  factory ArbPlaceholder.fromMap(Map<String, dynamic> map) {
    return ArbPlaceholder(
      name: map['name'] ?? '',
      type: ArbType.values.byName(map['type']),
    );
  }
}
