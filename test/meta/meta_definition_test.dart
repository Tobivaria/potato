import 'package:flutter_test/flutter_test.dart';
import 'package:potato/meta/meta_definition.dart';
import 'package:potato/meta/placeholder/meta_placerholder.dart';

void main() {
  test('Description and single placeholder to map', () {
    const MetaDefinition definition = MetaDefinition(
      description: 'Some text',
      placeholders: [MetaPlaceholder(id: 'value', type: MetaType.String)],
    );
    final Map<String, dynamic> expected = {
      'description': 'Some text',
      'placeholders': {
        'value': {'type': 'String'}
      }
    };

    expect(definition.toMap(), expected);
  });

  test('Description and multiple placeholders to map', () {
    const MetaDefinition definition = MetaDefinition(
      description: 'Some text',
      placeholders: [
        MetaPlaceholder(id: 'value', type: MetaType.String),
        MetaPlaceholder(id: 'person', type: MetaType.DateTime),
        MetaPlaceholder(id: 'hola', type: MetaType.double),
      ],
    );
    final Map<String, dynamic> expected = {
      'description': 'Some text',
      'placeholders': {
        'value': {'type': 'String'},
        'person': {'type': 'DateTime'},
        'hola': {'type': 'double'}
      }
    };

    expect(definition.toMap(), expected);
  });

  test('MetaDefinition from Map', () {
    final Map<String, dynamic> source = {
      'description': 'Some text',
      'placeholders': {
        'value': {'type': 'String'},
        'person': {'type': 'DateTime'},
        'hola': {'type': 'double'}
      }
    };

    const MetaDefinition expected = MetaDefinition(
      description: 'Some text',
      placeholders: [
        MetaPlaceholder(id: 'value', type: MetaType.String),
        MetaPlaceholder(id: 'person', type: MetaType.DateTime),
        MetaPlaceholder(id: 'hola', type: MetaType.double),
      ],
    );

    expect(MetaDefinition.fromMap(source), expected);
  });
}
