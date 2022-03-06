import 'package:fluent_ui/fluent_ui.dart';

enum ArbType {
  // ignore: constant_identifier_names
  String,
}

@immutable
class ArbDefinition {
  final ArbPlaceholder? type;
  final String? description;
  final List<ArbPlaceholder>? placeholders;

  const ArbDefinition({this.type, this.description, this.placeholders});

  factory ArbDefinition.fromMap(Map<String, dynamic> map) {
    return ArbDefinition(
      type: map['type'],
      description: map['description'],
      placeholders: map['placeholders'] != null
          ? List<ArbPlaceholder>.from(map['placeholders']?.map((x) => ArbPlaceholder.fromMap(x)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'description': description,
      'placeholders': placeholders?.map((x) => x.toMap()).toList(),
    };
  }
}

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
      'name': name,
      'type': ArbType.String.name,
    };
  }

  factory ArbPlaceholder.fromMap(Map<String, dynamic> map) {
    return ArbPlaceholder(
      name: map['name'] ?? '',
      type: ArbType.values.byName(map['type']),
    );
  }
}
