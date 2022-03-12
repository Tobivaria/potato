import 'package:flutter/foundation.dart';

import 'arb_placerholder.dart';

enum ArbType {
  // ignore: constant_identifier_names
  String,
  double,
  int,
  // ignore: constant_identifier_names
  DateTime
}

@immutable
class ArbDefinition {
  final ArbType? type;
  final String? description;
  final List<ArbPlaceholder>? placeholders;

  const ArbDefinition({this.type, this.description, this.placeholders});

  factory ArbDefinition.fromMap(Map<String, dynamic> map) {
    // TODO placeholders
    return ArbDefinition(type: ArbType.values.byName(map['type']), description: map['description'], placeholders: null);
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'description': description,
      // TODO placeholders
      'placeholders': null,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArbDefinition &&
        other.type == type &&
        other.description == description &&
        listEquals(other.placeholders, placeholders);
  }

  @override
  int get hashCode => type.hashCode ^ description.hashCode ^ placeholders.hashCode;
}
