import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potato/language/language.dart';
import 'package:potato/project/project.dart';
import 'package:potato/translation/arb_definition.dart';

void main() {
  test('Create new project', () {
    Project project = Project(baseLanguage: 'en');
    expect(project.baseLanguage, 'en');
    expect(project.path, isNull);
    expect(mapEquals(project.languages, {'en': Language()}), isTrue);
    expect(mapEquals(project.arbDefinitions, {}), isTrue);
  });

  test('Copy project', () {
    const String baseLanguage = 'de';
    const String path = 'some/path';
    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo'})
    };
    final Map<String, ArbDefinition> arbDefinitions = {'greeting': const ArbDefinition(description: 'Lul')};

    Project project = Project(baseLanguage: 'en');
    Project copy =
        project.copyWith(baseLang: baseLanguage, path: path, languages: languages, arbDefinitions: arbDefinitions);

    expect(copy.baseLanguage, 'de');
    expect(copy.path, path);
    expect(copy.languages, languages);
    expect(mapEquals(copy.languages, languages), isTrue);
    expect(mapEquals(copy.arbDefinitions, arbDefinitions), isTrue);
  });

  test('Create project from map', () {
    const String baseLanguage = 'de';
    const String path = 'some/path';

    Project project = Project.fromMap(const {'baseLanguage': baseLanguage, 'path': path});

    expect(project.baseLanguage, 'de');
    expect(project.path, path);
  });

  test('Convert project to map', () {
    const String baseLanguage = 'de';
    const String path = 'some/path';
    const Map<String, String> expected = {'baseLanguage': baseLanguage, 'path': path, 'version': '1'};

    Project project = Project(baseLanguage: baseLanguage, path: path);
    expect(mapEquals(project.toMap(), expected), isTrue);
  });

  test('Return available language list', () {
    const String baseLanguage = 'de';
    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo'})
    };

    Project project = Project(baseLanguage: baseLanguage, existingLanguages: languages);

    expect(listEquals(project.supportedLanguages(), ['en', 'de']), isTrue);
  });

  test('Export a language entry', () {
    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello', 'bye': 'goodbye'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo', 'bye': 'tschüss'})
    };

    Project project = Project(baseLanguage: 'en', existingLanguages: languages);
    const Map<String, dynamic> expected = {'@@locale': 'de', 'bye': 'tschüss', 'greeting': 'hallo'};

    expect(project.exportLanguage('de', ['bye', 'greeting']), expected);
  });

  test('Export base language', () {
    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello', 'bye': 'goodbye'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo', 'bye': 'tschüss'})
    };
    final Map<String, ArbDefinition> arbDefinitions = {
      'bye': const ArbDefinition(description: 'Saying goodbye'),
      'greeting': const ArbDefinition(description: 'Saying hello')
    };

    Project project =
        Project(baseLanguage: 'en', existingLanguages: languages, existingArdbDefinitions: arbDefinitions);

    const Map<String, dynamic> expected = {
      '@@locale': 'en',
      'bye': 'goodbye',
      '@bye': {'type': null, 'description': 'Saying goodbye', 'placeholders': null},
      'greeting': 'hello',
      '@greeting': {'type': null, 'description': 'Saying hello', 'placeholders': null}
    };

    expect(project.exportLanguage('en', ['bye', 'greeting']), expected);
  });
}
