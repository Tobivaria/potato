import 'package:flutter/foundation.dart';
import 'package:potato/meta/placeholder/meta_placerholder.dart';

enum MetaType {
  // ignore: constant_identifier_names
  String,
  double,
  int,
  // ignore: constant_identifier_names
  DateTime
}

@immutable
class MetaDefinition {
  final String? description;
  final List<MetaPlaceholder>? placeholders;

  const MetaDefinition({this.description, this.placeholders});

  factory MetaDefinition.fromMap(Map<String, dynamic> map) {
    List<MetaPlaceholder>? placeholderList;

    if (map['placeholders'] != null) {
      placeholderList = [];
      final Map<String, dynamic> placeholderMap =
          map['placeholders'] as Map<String, dynamic>;
      for (final MapEntry<String, dynamic> entry in placeholderMap.entries) {
        placeholderList.add(MetaPlaceholder.fromMap(entry));
      }
    }
    return MetaDefinition(
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

  MetaDefinition copyWith({
    String? description,
    List<MetaPlaceholder>? placeholders,
  }) {
    return MetaDefinition(
      description: description ?? this.description,
      placeholders: placeholders ?? this.placeholders,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MetaDefinition &&
        other.description == description &&
        listEquals(other.placeholders, placeholders);
  }

  @override
  int get hashCode => description.hashCode ^ placeholders.hashCode;

  @override
  String toString() =>
      'MetaDefinition(description: $description, placeholders: $placeholders)';
}
