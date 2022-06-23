import 'package:flutter_test/flutter_test.dart';
import 'package:potato/meta/meta_definition.dart';
import 'package:potato/meta/placeholder/meta_placerholder.dart';
import 'package:potato/translation/translation_verification.dart';

void main() {
  group('Verify placeholders in string', () {
    test('Missing placeholder return an error', () {
      const String input = '';
      const MetaDefinition definition = MetaDefinition(
        placeholders: [MetaPlaceholder(id: 'value', type: MetaType.String)],
      );

      final TranslationVerification validator =
          TranslationVerification(definition, input);

      expect(
        validator.verifyPlaceholder(),
        TranslationStatus.missingPlaceholder,
      );
    });

    test('Too many placeholder return an error', () {
      const String input = 'Something {value} lala {again}';
      const MetaDefinition definition = MetaDefinition(
        placeholders: [MetaPlaceholder(id: 'value', type: MetaType.String)],
      );

      final TranslationVerification validator =
          TranslationVerification(definition, input);

      expect(
        validator.verifyPlaceholder(),
        TranslationStatus.tooMuchPlaceholder,
      );
    });

    test('Wrongly named placeholder return an error', () {
      const String input = 'Something {val} lala';
      const MetaDefinition definition = MetaDefinition(
        placeholders: [MetaPlaceholder(id: 'value', type: MetaType.String)],
      );

      final TranslationVerification validator =
          TranslationVerification(definition, input);

      expect(
        validator.verifyPlaceholder(),
        TranslationStatus.placeholderDoesNotExist,
      );
    });

    test('Valid string return no error', () {
      const String input = 'Something {val} lala {}';
      const MetaDefinition definition = MetaDefinition(
        placeholders: [
          MetaPlaceholder(id: '', type: MetaType.String),
          MetaPlaceholder(id: 'val', type: MetaType.String)
        ],
      );

      final TranslationVerification validator =
          TranslationVerification(definition, input);

      expect(validator.verifyPlaceholder(), TranslationStatus.okay);
    });
  });
}
