import 'package:flutter_test/flutter_test.dart';
import 'package:potato/meta/meta_number_options.dart';

void main() {
  group('Number options base toMap', () {
    test('Empty options return null', () {
      expect(const MetaNumberOptionsBase().toMap(), isNull);
    });
    test('Set digit count is represented in map', () {
      final Map<String, dynamic> expected = {'decimalDigits': 2};
      const MetaNumberOptionsBase options =
          MetaNumberOptionsBase(decimalCount: 2);

      expect(options.toMap(), expected);
    });
  });

  group('Number options Simple toMap', () {
    test('Empty options return null', () {
      expect(const MetaNumberOptionsSimple().toMap(), isNull);
    });

    test('Set name and digit count is represented in map', () {
      final Map<String, dynamic> expected = {
        'decimalDigits': 2,
        'name': 'Solo'
      };
      const MetaNumberOptionsSimple options =
          MetaNumberOptionsSimple(name: 'Solo', decimalCount: 2);

      expect(options.toMap(), expected);
    });
  });

  group('Number options extended toMap', () {
    test('Empty options return null', () {
      expect(const MetaNumberOptionsExtended().toMap(), isNull);
    });

    test('Set name and digit count is represented in map', () {
      final Map<String, dynamic> expected = {
        'decimalDigits': 2,
        'name': 'Solo',
        'symbol': '€'
      };
      const MetaNumberOptionsExtended options = MetaNumberOptionsExtended(
        symbol: '€',
        name: 'Solo',
        decimalCount: 2,
      );

      expect(options.toMap(), expected);
    });
  });

  group('Number options full toMap', () {
    test('Empty options return null', () {
      expect(const MetaNumberOptionsFull().toMap(), isNull);
    });

    test('Set name and digit count is represented in map', () {
      final Map<String, dynamic> expected = {
        'decimalDigits': 2,
        'name': 'Solo',
        'symbol': '€',
        'customPattern': '#0.00'
      };
      const MetaNumberOptionsFull options = MetaNumberOptionsFull(
        pattern: '#0.00',
        symbol: '€',
        name: 'Solo',
        decimalCount: 2,
      );

      expect(options.toMap(), expected);
    });
  });
}
