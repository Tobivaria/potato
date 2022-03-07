import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potato/language/language.dart';

void main() {
  test('Create new language', () {
    Language lang = Language();
    mapEquals(lang.translations, {});
  });

  test('Create language with existing keys', () {
    Language baseLang = Language(existingTranslations: const {'key1': 'hello', 'key2': 'bye'});
    Language lang = Language.copyEmpty(baseLang);

    mapEquals(lang.translations, {'key1': '', 'key2': ''});
  });

  test('Copy language', () {
    Map<String, String> translations = const {'key1': 'hello', 'key2': 'bye'};
    Language lang = Language();
    Language copy = lang.copyWith(translations: translations);

    expect(mapEquals(copy.translations, translations), isTrue);
  });

  test('Get translation', () {
    Language lang = Language(existingTranslations: const {'key1': 'hello', 'key2': 'bye'});
    expect(lang.getTranslation('key1'), 'hello');
  });

  test('Get translation count', () {
    Language lang = Language(existingTranslations: const {'key1': 'hello', 'key2': 'bye'});
    expect(lang.getTranslationCount(), 2);
  });

  test('Add translation', () {
    // empty language
    Language lang = Language();
    lang.addTranslation('newKey', 'New entry!');
    expect(mapEquals(lang.translations, {'newKey': 'New entry!'}), isTrue);

    // language with pre-existing translations
    lang = Language(existingTranslations: const {'key1': 'hello', 'key2': 'bye'});
    lang.addTranslation('newKey', 'New entry!');
    expect(mapEquals(lang.translations, {'key1': 'hello', 'key2': 'bye', 'newKey': 'New entry!'}), isTrue);
  });

  test('Removed translation', () {
    Language lang = Language(existingTranslations: const {'key1': 'hello', 'key2': 'bye'});
    lang.deleteTranslation('key1');

    expect(mapEquals(lang.translations, {'key2': 'bye'}), isTrue);
  });
}
