import 'package:potato/arb/arb_definition.dart';
import 'package:potato/arb/arb_placerholder.dart';
import 'package:potato/language/language.dart';
import 'package:potato/language/language_data.dart';

extension MutableLanguageData on LanguageData {
  LanguageData _updateLanguage(
    String language,
    Language updatedLanguage,
  ) {
    final Map<String, Language> modifiedLanguages = {};
    for (final String entry in languages.keys) {
      if (entry == language) {
        modifiedLanguages[entry] = updatedLanguage;
      } else {
        modifiedLanguages[entry] = languages[entry]!;
      }
    }
    return copyWith(
      languages: modifiedLanguages,
    );
  }

  LanguageData _updateMetaDefinition(String key, ArbDefinition updatedDef) {
    final Map<String, ArbDefinition> modifiedDefs = {};
    for (final String entry in arbDefinitions.keys) {
      if (entry == key) {
        modifiedDefs[entry] = updatedDef;
      } else {
        modifiedDefs[entry] = arbDefinitions[entry]!;
      }
    }
    return copyWith(
      arbDefinitions: modifiedDefs,
    );
  }

////////////////////////////////////////////////////////////////////
// Language ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

  LanguageData addLanguage(String langKey) {
    final Map<String, String> newLanguage = {};
    for (final entry in arbDefinitions.keys) {
      newLanguage[entry] = '';
    }

    return copyWith(
      languages: {
        ...languages,
        langKey: Language(existingTranslations: newLanguage)
      },
    );
  }

  LanguageData removeLanguage(String langToRemove) {
    final Map<String, Language> previousLanguages = {...languages};
    previousLanguages.remove(langToRemove);

    return copyWith(languages: previousLanguages);
  }

////////////////////////////////////////////////////////////////////
// Translation /////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

  LanguageData updateTranslation(
    String langKey,
    String key,
    String translation,
  ) {
    final Map<String, String> modified =
        Map.of(languages[langKey]!.translations);
    modified[key] = translation;

    return _updateLanguage(
      langKey,
      Language(existingTranslations: modified),
    );
  }

////////////////////////////////////////////////////////////////////
// Meta key ////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

  /// Adds a new translation with given key
  /// When no key is given a predefined key is used
  LanguageData addKey() {
    const String emptyKey = '@Addkey';
    String keyToInsert = emptyKey;

    // TODO add test for that part
    // as the key needs to be unique for new entries, increment count
    final RegExp reg = RegExp(r'\d+');
    while (arbDefinitions.keys.contains(keyToInsert)) {
      final RegExpMatch? match = reg.firstMatch(keyToInsert);

      if (match == null) {
        // no number previously attached
        keyToInsert += ' 1';
        continue;
      }
      final String? intStr = match.group(0);

      keyToInsert = '$emptyKey ${(int.tryParse(intStr!) ?? 0) + 1}';
    }

    final Map<String, Language> modifiedLanguages = {};

    for (final item in languages.keys) {
      modifiedLanguages[item] = Language(
        existingTranslations: {
          ...languages[item]!.translations,
          keyToInsert: ''
        },
      );
    }

    return LanguageData(
      existingArdbDefinitions: {
        ...arbDefinitions,
        keyToInsert: const ArbDefinition()
      },
      existingLanguages: modifiedLanguages,
    );
  }

  /// Removes the key itself and from all languages
  LanguageData removeKey(String key) {
    final Map<String, Language> modifiedLanguages = {};

    // create a copy of each language
    for (final languageKey in languages.keys) {
      final Map<String, String> copy =
          Map.of(languages[languageKey]!.translations);
      copy.remove(key)!;
      modifiedLanguages[languageKey] = Language(existingTranslations: copy);
    }

    final Map<String, ArbDefinition> arbDefs = {...arbDefinitions};
    arbDefs.remove(key)!;

    return LanguageData(
      existingArdbDefinitions: arbDefs,
      existingLanguages: modifiedLanguages,
    );
  }

  /// Updates the key in the meta definition and all languages, by removing the previous entry and creating a new one
  LanguageData updateKey(String key, String updatedKey) {
    final Map<String, Language> modifiedLanguages = {};

    // create a copy of each language
    // cache the translation
    // remove the invalidated key
    // create a new key entry, with cached translation
    for (final languageKey in languages.keys) {
      final Map<String, String> copy =
          Map.of(languages[languageKey]!.translations);
      final String removedTranslation = copy.remove(key)!;
      copy[updatedKey] = removedTranslation;
      modifiedLanguages[languageKey] = Language(existingTranslations: copy);
    }

    final Map<String, ArbDefinition> arbDefs = {...arbDefinitions};
    final ArbDefinition removedDef = arbDefs.remove(key)!;
    arbDefs[updatedKey] = removedDef;

    return LanguageData(
      existingArdbDefinitions: arbDefs,
      existingLanguages: modifiedLanguages,
    );
  }

////////////////////////////////////////////////////////////////////
// Meta description ////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

  /// Adds a default description
  LanguageData addDescription(String key) {
    return _updateMetaDefinition(
      key,
      arbDefinitions[key]!.copyWith(description: ''),
    );
  }

  LanguageData removeDescription(String key) {
    return _updateMetaDefinition(
      key,
      ArbDefinition(
        placeholders: arbDefinitions[key]?.placeholders,
      ),
    );
  }

  LanguageData updateDescription(String key, String description) {
    return _updateMetaDefinition(
      key,
      arbDefinitions[key]!.copyWith(description: description),
    );
  }

////////////////////////////////////////////////////////////////////
// Meta placeholder ////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

  /// Validates that for the definition key does not already exist a placeholder with the same id
  bool isPlaceholderIdUnique(String key, String placeholderId) {
    final List<ArbPlaceholder>? placeholders =
        arbDefinitions[key]!.placeholders;

    if (placeholders == null) {
      return true;
    }

    return !placeholders.any((element) => element.id == placeholderId);
  }

  /// Add a default placeholder
  LanguageData addPlaceholder(String key) {
    const String defaultId = '';
    const MetaType defaultType = MetaType.String;

    String placeHolderKey = defaultId;

    // as the key needs to be unique for new entries, increment count
    final RegExp reg = RegExp(r'\d+');
    if (arbDefinitions[key]!.placeholders != null) {
      while (isPlaceholderIdUnique(key, placeHolderKey)) {
        final RegExpMatch? match = reg.firstMatch(placeHolderKey);

        if (match == null) {
          // no number previously attached
          placeHolderKey += '1';
          continue;
        }
        final String? intStr = match.group(0);

        placeHolderKey = '$defaultId ${(int.tryParse(intStr!) ?? 0) + 1}';
      }
    }

    final ArbDefinition orig = arbDefinitions[key]!;
    final ArbDefinition modified = orig.copyWith(
      placeholders: [
        ...?orig.placeholders,
        ArbPlaceholder(id: placeHolderKey, type: defaultType)
      ],
    );

    return _updateMetaDefinition(key, modified);
  }

  /// Update any data of a placeholder
  LanguageData updatePlaceholder({
    required String key,
    required String id,
    String? updatedId,
    String? updatedExample,
    MetaType? updatedType,
  }) {
    final ArbDefinition orig = arbDefinitions[key]!;
    final ArbDefinition modified = orig.copyWith(
      placeholders: [
        for (ArbPlaceholder placeholder in orig.placeholders!)
          if (placeholder.id == id)
            placeholder.copyWith(
              id: updatedId,
              example: updatedExample,
              type: updatedType,
            )
          else
            placeholder
      ],
    );

    return _updateMetaDefinition(key, modified);
  }

  /// Removes the placeholder by its id of the definition key
  LanguageData removePlaceHolder(String key, String placeholderId) {
    final ArbDefinition orig = arbDefinitions[key]!;

    final ArbDefinition modified = arbDefinitions[key]!.copyWith(
      placeholders: [
        for (ArbPlaceholder placeholder in orig.placeholders!)
          if (placeholder.id != placeholderId) placeholder
      ],
    );

    return _updateMetaDefinition(key, modified);
  }
}
