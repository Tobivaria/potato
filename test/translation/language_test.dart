import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potato/language/language.dart';

void main() {
  group('Constructors', () {
    test('Default', () {
      Language lang = Language();
      mapEquals(lang.translations, {});
    });

    test('Copy from base language', () {
      Language baseLang = Language(existingTranslations: {'key1': 'hello', 'key2': 'bye'});
      Language lang = Language.copyEmpty(baseLang);

      mapEquals(lang.translations, {'key1': '', 'key2': ''});
    });
  });

  group('Methods', () {
    test('Get translation', () {
      Language lang = Language(existingTranslations: {'key1': 'hello', 'key2': 'bye'});
      expect(lang.getTranslation('key1'), 'hello');
    });

    test('Add translation', () {
      // empty language
      Language lang = Language();
      lang.addTranslation('newKey', 'New entry!');
      expect(mapEquals(lang.translations, {'newKey': 'New entry!'}), isTrue);

      // language with pre-existing translations
      lang = Language(existingTranslations: {'key1': 'hello', 'key2': 'bye'});
      lang.addTranslation('newKey', 'New entry!');
      expect(mapEquals(lang.translations, {'key1': 'hello', 'key2': 'bye', 'newKey': 'New entry!'}), isTrue);
    });

    test('Removed translation', () {
      Language lang = Language(existingTranslations: {'key1': 'hello', 'key2': 'bye'});
      lang.deleteTranslation('key1');

      expect(mapEquals(lang.translations, {'key2': 'bye'}), isTrue);
    });
  });
}
