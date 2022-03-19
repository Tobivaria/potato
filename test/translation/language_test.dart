import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potato/language/language.dart';

void main() {
  test('Create new language', () {
    Language lang = Language();
    mapEquals(lang.translations, {});
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
}
