import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potato/language/language.dart';

void main() {
  test('Create new language', () {
    final Language lang = Language();
    mapEquals(lang.translations, {});
  });

  test('Copy language', () {
    const Map<String, String> translations = {'key1': 'hello', 'key2': 'bye'};
    final Language lang = Language();
    final Language copy = lang.copyWith(translations: translations);

    expect(mapEquals(copy.translations, translations), isTrue);
  });

  test('Get translation', () {
    final Language lang = Language(existingTranslations: const {'key1': 'hello', 'key2': 'bye'});
    expect(lang.getTranslation('key1'), 'hello');
  });

  test('Get translation count', () {
    final Language lang = Language(existingTranslations: const {'key1': 'hello', 'key2': 'bye'});
    expect(lang.getTranslationCount(), 2);
  });
}
