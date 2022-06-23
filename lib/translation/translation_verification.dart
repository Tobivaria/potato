import 'package:potato/meta/meta_definition.dart';
import 'package:potato/meta/placeholder/meta_placerholder.dart';

typedef Validator = TranslationStatus Function();

enum TranslationStatus {
  okay,
  missingPlaceholder,
  tooMuchPlaceholder,
  placeholderDoesNotExist
}

/// Helper class, which presents utilities, to verify translations are consistent with the meta definition, e.g. containing placeholders
class TranslationVerification {
  final MetaDefinition metaDefinition;
  final String translation;

  List<Validator> _validators =
      []; // list of validator functions, which are executed in the order of the list

  TranslationVerification(this.metaDefinition, this.translation) {
    _validators = [verifyPlaceholder];
  }

  TranslationStatus verify() {
    for (final Validator validator in _validators) {
      final TranslationStatus out = validator();
      if (out != TranslationStatus.okay) {
        return out;
      }
    }
    return TranslationStatus.okay;
  }

  /// Validates that the translation string, contains the number of placeholders and their names
  TranslationStatus verifyPlaceholder() {
    if (metaDefinition.placeholders != null) {
      final RegExp reg = RegExp(r'\{(.*?)\}');
      final Iterable<RegExpMatch> result = reg.allMatches(translation);

      final int expectedPlaceholderCount = metaDefinition.placeholders!.length;

      if (result.length < expectedPlaceholderCount) {
        return TranslationStatus.missingPlaceholder;
      }
      if (result.length > expectedPlaceholderCount) {
        return TranslationStatus.tooMuchPlaceholder;
      }

      final List<String> definedNames = [];
      for (final MetaPlaceholder entry in metaDefinition.placeholders!) {
        definedNames.add(entry.id);
      }

      for (final RegExpMatch entry in result) {
        for (int i = 1; i <= entry.groupCount; i++) {
          final String placeholderName = entry.group(i) ?? '';
          if (!definedNames.contains(placeholderName)) {
            return TranslationStatus.placeholderDoesNotExist;
          }
        }
      }
    }

    return TranslationStatus.okay;
  }
}
