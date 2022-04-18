import 'package:flutter_test/flutter_test.dart';
import 'package:potato/arb/arb_number_options.dart';

void main() {
  group('Number options base toMap', () {
    test('Empty options return null', () {
      expect(const ArbNumberOptionsBase().toMap(), isNull);
    });
    test('Set digit count is represented in map', () {
      final Map<String, dynamic> expected = {'decimalDigits': 2};
      const ArbNumberOptionsBase options =
          ArbNumberOptionsBase(decimalCount: 2);

      expect(options.toMap(), expected);
    });
  });

  group('Number options Simple toMap', () {
    test('Empty options return null', () {
      expect(const ArbNumberOptionsSimple().toMap(), isNull);
    });

    test('Set name and digit count is represented in map', () {
      final Map<String, dynamic> expected = {
        'decimalDigits': 2,
        'name': 'Solo'
      };
      const ArbNumberOptionsSimple options =
          ArbNumberOptionsSimple(name: 'Solo', decimalCount: 2);

      expect(options.toMap(), expected);
    });
  });

  group('Number options extended toMap', () {
    test('Empty options return null', () {
      expect(const ArbNumberOptionsExtended().toMap(), isNull);
    });

    test('Set name and digit count is represented in map', () {
      final Map<String, dynamic> expected = {
        'decimalDigits': 2,
        'name': 'Solo',
        'symbol': '€'
      };
      const ArbNumberOptionsExtended options = ArbNumberOptionsExtended(
        symbol: '€',
        name: 'Solo',
        decimalCount: 2,
      );

      expect(options.toMap(), expected);
    });
  });

  group('Number options full toMap', () {
    test('Empty options return null', () {
      expect(const ArbNumberOptionsFull().toMap(), isNull);
    });

    test('Set name and digit count is represented in map', () {
      final Map<String, dynamic> expected = {
        'decimalDigits': 2,
        'name': 'Solo',
        'symbol': '€',
        'customPattern': '#0.00'
      };
      const ArbNumberOptionsFull options = ArbNumberOptionsFull(
        pattern: '#0.00',
        symbol: '€',
        name: 'Solo',
        decimalCount: 2,
      );

      expect(options.toMap(), expected);
    });
  });
}
