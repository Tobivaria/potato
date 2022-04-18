import 'package:flutter_test/flutter_test.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/arb/arb_placerholder.dart';

void main() {
  test('String placeholder to map', () {
    ArbPlaceholder placeholder = const ArbPlaceholder(id: 'value', type: ArbType.String);
    Map<String, dynamic> expected = {
      'value': {'type': 'String'}
    };

    expect(placeholder.toMap(), expected);

    // with example
    placeholder = const ArbPlaceholder(id: 'value', type: ArbType.String, example: 'Blabla lila');
    expected = {
      'value': {'type': 'String', 'example': 'Blabla lila'}
    };

    expect(placeholder.toMap(), expected);
  });

  test('Number placeholder to map', () {
    const ArbPlaceholder placeholder = ArbPlaceholder(id: 'value', type: ArbType.int);
    const Map<String, dynamic> expected = <String, dynamic>{
      'value': {
        'type': 'int',
      }
    };

    expect(placeholder.toMap(), expected);
  });

  test('Placeholder from Map', () {
    MapEntry<String, dynamic> source =
        const MapEntry<String, dynamic>('value', {'type': 'String', 'example': 'Blabla lila'});
    ArbPlaceholder expected = const ArbPlaceholder(id: 'value', type: ArbType.String, example: 'Blabla lila');

    expect(ArbPlaceholder.fromMap(source), expected);

    // number with format
    source =
        const MapEntry<String, dynamic>('value', {'type': 'double', 'example': 'Blabla lila', 'format': 'compactLong'});
    expected = const ArbPlaceholder(
      id: 'value',
      type: ArbType.double,
      example: 'Blabla lila',
    );

    expect(ArbPlaceholder.fromMap(source), expected);
  });
}
