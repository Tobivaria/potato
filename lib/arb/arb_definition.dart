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
  final String? description;
  final List<ArbPlaceholder>? placeholders;

  const ArbDefinition({this.description, this.placeholders});

  factory ArbDefinition.fromMap(Map<String, dynamic> map) {
    List<ArbPlaceholder>? placeholderList;

    if (map['placeholders'] != null) {
      placeholderList = [];
      Map<String, dynamic> placeholderMap = map['placeholders'];
      for (MapEntry<String, dynamic> entry in placeholderMap.entries) {
        placeholderList.add(ArbPlaceholder.fromMap(entry));
      }
    }
    return ArbDefinition(description: map['description'], placeholders: placeholderList);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> out = {'description': description};

    if (placeholders != null) {
      Map<String, dynamic> placeholderMap = {};
      for (var entry in placeholders!) {
        placeholderMap.addAll(entry.toMap());
      }
      out['placeholders'] = placeholderMap;
    }

    return out;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArbDefinition && other.description == description && listEquals(other.placeholders, placeholders);
  }

  @override
  int get hashCode => description.hashCode ^ placeholders.hashCode;
}
