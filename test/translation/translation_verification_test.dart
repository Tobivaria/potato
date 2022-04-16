import 'package:flutter_test/flutter_test.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/arb/arb_placerholder.dart';
import 'package:potato/translation/translation_verification.dart';

void main() {
  group('Verify placeholders in string', () {
    test('Missing placeholder return an error', () {
      const String input = '';
      const ArbDefinition definition = ArbDefinition(placeholders: [ArbPlaceholder(id: 'value', type: ArbType.String)]);

      final TranslationVerification validator = TranslationVerification(definition, input);

      expect(validator.verifyPlaceholder(), TranslationStatus.missingPlaceholder);
    });

    test('Too many placeholder return an error', () {
      const String input = 'Something {value} lala {again}';
      const ArbDefinition definition = ArbDefinition(placeholders: [ArbPlaceholder(id: 'value', type: ArbType.String)]);

      final TranslationVerification validator = TranslationVerification(definition, input);

      expect(validator.verifyPlaceholder(), TranslationStatus.tooMuchPlaceholder);
    });

    test('Wrongly named placeholder return an error', () {
      const String input = 'Something {val} lala';
      const ArbDefinition definition = ArbDefinition(placeholders: [ArbPlaceholder(id: 'value', type: ArbType.String)]);

      final TranslationVerification validator = TranslationVerification(definition, input);

      expect(validator.verifyPlaceholder(), TranslationStatus.placeholderDoesNotExist);
    });

    test('Valid string return no error', () {
      const String input = 'Something {val} lala {}';
      const ArbDefinition definition = ArbDefinition(
        placeholders: [ArbPlaceholder(id: '', type: ArbType.String), ArbPlaceholder(id: 'val', type: ArbType.String)],
      );

      final TranslationVerification validator = TranslationVerification(definition, input);

      expect(validator.verifyPlaceholder(), TranslationStatus.okay);
    });
  });
}
