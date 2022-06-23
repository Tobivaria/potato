import 'package:flutter/foundation.dart';
import 'package:potato/language/language.dart';
import 'package:potato/meta/meta_definition.dart';
import 'package:potato/settings/settings.dart';

/// Holds the state of the currently loaded project
@immutable
class LanguageData {
  final Map<String, Language> languages; // langCode
  final Map<String, MetaDefinition> metaDefinitions; // translation key

  LanguageData({
    Map<String, Language>? existingLanguages,
    Map<String, MetaDefinition>? existingArdbDefinitions,
  })  : languages = existingLanguages ?? <String, Language>{},
        metaDefinitions = existingArdbDefinitions ?? <String, MetaDefinition>{};

  List<String> supportedLanguages() {
    return languages.keys.toList();
  }

  /// Creates a ordered map of the given language key, in the meta format
  Map<String, dynamic> exportLanguage(
    String langKey,
    List<String> keyOrder, {
    bool isMainLanguage = false,
    EmptyTranslation? emptyTranslation,
    Language? mainLanguage,
  }) {
    final Map<String, dynamic> export = <String, dynamic>{'@@locale': langKey};

    if (isMainLanguage) {
      final Map<String, String> mainTranslations =
          languages[langKey]!.translations;
      // add one key after the other
      for (final String key in keyOrder) {
        export[key] = mainTranslations[key];
        export['@$key'] = metaDefinitions[key]!.toMap();
      }
    } else {
      for (final String key in keyOrder) {
        final String val = languages[langKey]!.translations[key]!;
        if (val.isEmpty) {
          // TODO test this
          switch (emptyTranslation) {
            case EmptyTranslation.exportEmpty:
              export[key] = languages[langKey]!.translations[key];
              break;
            case EmptyTranslation.copyMainLanguage:
              export[key] = mainLanguage?.translations[key];
              break;

            case EmptyTranslation.noExport:
            default:
            // do nothing
          }
        } else {
          export[key] = languages[langKey]!.translations[key];
        }
      }
    }
    return export;
  }

  LanguageData copyWith({
    Map<String, Language>? languages,
    Map<String, MetaDefinition>? metas,
  }) {
    return LanguageData(
      existingLanguages: languages ?? this.languages,
      existingArdbDefinitions: metas ?? metaDefinitions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LanguageData &&
        mapEquals(other.languages, languages) &&
        mapEquals(other.metaDefinitions, metaDefinitions);
  }

  @override
  int get hashCode {
    return languages.hashCode ^ metaDefinitions.hashCode;
  }
}
