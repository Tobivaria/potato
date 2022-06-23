import 'package:fluent_ui/fluent_ui.dart';
import 'package:potato/meta/meta_definition.dart';

@immutable
class MetaPlaceholder {
  final String id;
  final MetaType type;
  final String? example;

  const MetaPlaceholder({required this.id, required this.type, this.example});

  factory MetaPlaceholder.fromMap(MapEntry<String, dynamic> map) {
    final entries = map.value as Map<String, dynamic>;

    return MetaPlaceholder(
      id: map.key,
      type: MetaType.values.byName(entries['type'] as String),
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

  MetaPlaceholder copyWith({
    String? id,
    MetaType? type,
    String? example,
  }) {
    return MetaPlaceholder(
      id: id ?? this.id,
      type: type ?? this.type,
      example: example ?? this.example,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MetaPlaceholder &&
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
      'MetaPlaceholder(id: $id, type: $type, example: $example)';
}
