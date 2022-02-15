import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potato/translation/language.dart';

void main() {
  group('Constructors', () {
    test('Default', () {
      Language lang = Language(locale: 'en');
      expect(lang.locale, 'en');
      mapEquals(lang.translations, {});
    });

    test('Copy from base language', () {
      Language baseLang = Language(locale: 'en', existingTranslations: {'key1': 'hello', 'key2': 'bye'});
      Language lang = Language.copyEmpty('de', baseLang);

      expect(lang.locale, 'de');
      mapEquals(lang.translations, {'key1': '', 'key2': ''});
    });
  });

  group('Methods', () {
    test('Get translation', () {
      Language lang = Language(locale: 'en', existingTranslations: {'key1': 'hello', 'key2': 'bye'});
      expect(lang.getTranslation('key1'), 'hello');
    });

    test('Add translation', () {
      // empty language
      Language lang = Language(locale: 'en');
      lang.addTranslation('newKey', 'New entry!');
      expect(lang.locale, 'en');
      expect(mapEquals(lang.translations, {'newKey': 'New entry!'}), isTrue);

      // language with pre-existing translations
      lang = Language(locale: 'en', existingTranslations: {'key1': 'hello', 'key2': 'bye'});
      lang.addTranslation('newKey', 'New entry!');
      expect(lang.locale, 'en');
      expect(mapEquals(lang.translations, {'key1': 'hello', 'key2': 'bye', 'newKey': 'New entry!'}), isTrue);
    });

    test('Removed translation', () {
      Language lang = Language(locale: 'en', existingTranslations: {'key1': 'hello', 'key2': 'bye'});
      lang.deleteTranslation('key1');

      expect(lang.locale, 'en');
      expect(mapEquals(lang.translations, {'key2': 'bye'}), isTrue);
    });
  });
}
