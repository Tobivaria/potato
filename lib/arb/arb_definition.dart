import 'package:flutter/foundation.dart';
import 'package:potato/arb/arb_placerholder.dart';

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
      final Map<String, dynamic> placeholderMap =
          map['placeholders'] as Map<String, dynamic>;
      for (final MapEntry<String, dynamic> entry in placeholderMap.entries) {
        placeholderList.add(ArbPlaceholder.fromMap(entry));
      }
    }
    return ArbDefinition(
      description: map['description'] as String?,
      placeholders: placeholderList,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> out = {'description': description};

    if (placeholders != null) {
      final Map<String, dynamic> placeholderMap = {};
      for (final entry in placeholders!) {
        placeholderMap.addAll(entry.toMap());
      }
      out['placeholders'] = placeholderMap;
    }

    return out;
  }

  ArbDefinition copyWith({
    String? description,
    List<ArbPlaceholder>? placeholders,
  }) {
    return ArbDefinition(
      description: description ?? this.description,
      placeholders: placeholders ?? this.placeholders,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ArbDefinition &&
        other.description == description &&
        listEquals(other.placeholders, placeholders);
  }

  @override
  int get hashCode => description.hashCode ^ placeholders.hashCode;

  @override
  String toString() =>
      'ArbDefinition(description: $description, placeholders: $placeholders)';
}
