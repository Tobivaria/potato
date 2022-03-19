import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:potato/arb/arb_definition.dart';
import 'package:potato/language/language.dart';
import 'package:potato/project/project_state.dart';

void main() {
  test('Create new project', () {
    ProjectState project = ProjectState();
    expect(mapEquals(project.languages, {'en': Language()}), isTrue);
    expect(mapEquals(project.arbDefinitions, {}), isTrue);
  });

  test('Copy project', () {
    const String path = 'some/path';
    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo'})
    };
    final Map<String, ArbDefinition> arbDefinitions = {'greeting': const ArbDefinition(description: 'Lul')};

    ProjectState project = ProjectState();
    ProjectState copy = project.copyWith(languages: languages, arbDefinitions: arbDefinitions);

    expect(copy.languages, languages);
    expect(mapEquals(copy.languages, languages), isTrue);
    expect(mapEquals(copy.arbDefinitions, arbDefinitions), isTrue);
  });

  test('Return available language list', () {
    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo'})
    };

    ProjectState project = ProjectState(existingLanguages: languages);

    expect(listEquals(project.supportedLanguages(), ['en', 'de']), isTrue);
  });

  test('Export a language entry', () {
    final Map<String, Language> languages = {
      'en': Language(existingTranslations: const {'greeting': 'hello', 'bye': 'goodbye'}),
      'de': Language(existingTranslations: const {'greeting': 'hallo', 'bye': 'tschüss'})
    };

    ProjectState project = ProjectState(existingLanguages: languages);
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

    ProjectState project = ProjectState(existingLanguages: languages, existingArdbDefinitions: arbDefinitions);

    const Map<String, dynamic> expected = {
      '@@locale': 'en',
      'bye': 'goodbye',
      '@bye': {'description': 'Saying goodbye'},
      'greeting': 'hello',
      '@greeting': {'description': 'Saying hello'}
    };

    expect(project.exportLanguage('en', ['bye', 'greeting']), expected);
  });
}