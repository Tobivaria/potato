import 'package:flutter_test/flutter_test.dart';
import 'package:potato/meta/meta_definition.dart';
import 'package:potato/meta/placeholder/meta_placerholder.dart';

void main() {
  test('String placeholder to map', () {
    MetaPlaceholder placeholder =
        const MetaPlaceholder(id: 'value', type: MetaType.String);
    Map<String, dynamic> expected = {
      'value': {'type': 'String'}
    };

    expect(placeholder.toMap(), expected);

    // with example
    placeholder = const MetaPlaceholder(
      id: 'value',
      type: MetaType.String,
      example: 'Blabla lila',
    );
    expected = {
      'value': {'type': 'String', 'example': 'Blabla lila'}
    };

    expect(placeholder.toMap(), expected);
  });

  test('Number placeholder to map', () {
    const MetaPlaceholder placeholder =
        MetaPlaceholder(id: 'value', type: MetaType.int);
    const Map<String, dynamic> expected = <String, dynamic>{
      'value': {
        'type': 'int',
      }
    };

    expect(placeholder.toMap(), expected);
  });

  test('Placeholder from Map', () {
    MapEntry<String, dynamic> source = const MapEntry<String, dynamic>(
      'value',
      {'type': 'String', 'example': 'Blabla lila'},
    );
    MetaPlaceholder expected = const MetaPlaceholder(
      id: 'value',
      type: MetaType.String,
      example: 'Blabla lila',
    );

    expect(MetaPlaceholder.fromMap(source), expected);

    // number with format
    source = const MapEntry<String, dynamic>(
      'value',
      {'type': 'double', 'example': 'Blabla lila', 'format': 'compactLong'},
    );
    expected = const MetaPlaceholder(
      id: 'value',
      type: MetaType.double,
      example: 'Blabla lila',
    );

    expect(MetaPlaceholder.fromMap(source), expected);
  });
}
