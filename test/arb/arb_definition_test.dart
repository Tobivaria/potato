import 'package:flutter_test/flutter_test.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/arb/arb_placerholder.dart';

void main() {
  test('Description and single placeholder to map', () {
    ArbDefinition definition = const ArbDefinition(
        description: 'Some text', placeholders: [ArbPlaceholder(id: 'value', type: ArbType.String)]);
    Map<String, dynamic> expected = {
      'description': 'Some text',
      'placeholders': {
        'value': {'type': 'String'}
      }
    };

    expect(definition.toMap(), expected);
  });

  test('Description and multiple placeholders to map', () {
    ArbDefinition definition = const ArbDefinition(description: 'Some text', placeholders: [
      ArbPlaceholder(id: 'value', type: ArbType.String),
      ArbPlaceholder(id: 'person', type: ArbType.DateTime),
      ArbPlaceholder(id: 'hola', type: ArbType.double),
    ]);
    Map<String, dynamic> expected = {
      'description': 'Some text',
      'placeholders': {
        'value': {'type': 'String'},
        'person': {'type': 'DateTime'},
        'hola': {'type': 'double'}
      }
    };

    expect(definition.toMap(), expected);
  });

  test('ArbDefinition from Map', () {
    Map<String, dynamic> source = {
      'description': 'Some text',
      'placeholders': {
        'value': {'type': 'String'},
        'person': {'type': 'DateTime'},
        'hola': {'type': 'double'}
      }
    };

    ArbDefinition expected = const ArbDefinition(description: 'Some text', placeholders: [
      ArbPlaceholder(id: 'value', type: ArbType.String),
      ArbPlaceholder(id: 'person', type: ArbType.DateTime),
      ArbPlaceholder(id: 'hola', type: ArbType.double),
    ]);

    expect(ArbDefinition.fromMap(source), expected);
  });
}
