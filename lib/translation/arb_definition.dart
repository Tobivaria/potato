import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';

@immutable
class ArbDefinition {
  final String? type; // TODO enum?
  final String? description;

  const ArbDefinition({this.type, this.description});

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'description': description,
    };
  }

  factory ArbDefinition.fromMap(Map<String, dynamic> map) {
    return ArbDefinition(
      type: map['type'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ArbDefinition.fromJson(String source) => ArbDefinition.fromMap(json.decode(source));
}
