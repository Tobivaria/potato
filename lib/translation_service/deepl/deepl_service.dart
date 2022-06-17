import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:potato/settings/settings_repository.dart';
import 'package:potato/translation_service/translation_config.dart';
import 'package:potato/translation_service/translation_service.dart';
import 'package:potato/translation_service/usage.dart';

class DeeplService extends TranslationService {
  static const String _baseUrl = 'https://api-free.deepl.com/v2/';

  /// Tag which will replace placeholders in the request, these tags are also ignored, and will not be translated
  static const String _replacePlaceholderTag = 'p';

  DeeplService({
    required Client client,
    required SettingsRepository preferencesRepository,
    required String name,
  }) : super(
          client: client,
          preferencesRepository: preferencesRepository,
          name: name,
        );

  @override
  String uniqueId() {
    return 'DeepLService';
  }

  // const TranslationConfig(
  //   sourceLang: 'EN',
  //   targetLang: 'DE',
  //   formality: 'less',
  // ),

  @override
  Future<String> translate(String toTranslate, TranslationConfig config) async {
    final String preparedTranslation = replacePlaceholderWithTag(toTranslate);
    final apiKey = await super.getApiKey();

    final Map<String, String> requestBody = <String, String>{
      'auth_key': apiKey,
      'text': preparedTranslation,
      'target_lang': config.targetLang,
      'source_Lang': config.sourceLang,
      'formality': 'less',
      'tag_handling': 'xml',
      'ignore_tags': _replacePlaceholderTag
    };

    const String url = '${_baseUrl}translate';
    String? translation;

    try {
      final Response response =
          await client.post(Uri.parse(url), body: requestBody);

      print(response);

      if (response.statusCode == 200) {
        // decode body bytes to get a valid utf-8 encoded string, otherwise there are issues with special chars like in spanish
        final utf8String = utf8.decode(response.bodyBytes);

        final Map<String, dynamic> responseJson =
            jsonDecode(utf8String) as Map<String, dynamic>;

        translation = extractTranslation(responseJson);
        if (translation != null) {
          translation = replaceTagWithPlaceholder(translation);
        }
      }
    } catch (e) {
      // TODO do something
    }

    return translation ?? '';
  }

  String? extractTranslation(Map<String, dynamic> responseJson) {
    if (responseJson.containsKey('translations')) {
      final List<dynamic> trans = responseJson['translations'] as List<dynamic>;

      if (trans.isNotEmpty) {
        final Map<String, dynamic> transMap = trans[0] as Map<String, dynamic>;

        if (transMap.containsKey('text')) {
          return transMap['text'] as String;
        }
      }
    }
    return null;
  }

  String replacePlaceholderWithTag(String val) {
    String out = val;
    final RegExp regExp = RegExp('{.*}');
    // replace placeholder brackets with placeholder xml
    if (regExp.hasMatch(val)) {
      out = out.replaceAll('{', '<$_replacePlaceholderTag>');
      out = out.replaceAll('}', '</$_replacePlaceholderTag>');
    }
    return out;
  }

  String replaceTagWithPlaceholder(String val) {
    String out = val;
    final RegExp regExp = RegExp('<p>.*</p>');
    // replace placeholder brackets with placeholder xml
    if (regExp.hasMatch(val)) {
      out = out.replaceAll('<$_replacePlaceholderTag>', '{');
      out = out.replaceAll('</$_replacePlaceholderTag>', '}');
    }
    return out;
  }

  @override
  Future<DeeplUsage?> getUsage() async {
    const String url = '${_baseUrl}usage';
    final apiKey = await super.getApiKey();

    final Map<String, String> requestBody = <String, String>{
      'auth_key': apiKey
    };

    try {
      final Response response =
          await client.post(Uri.parse(url), body: requestBody);

      if (response.statusCode == 200) {
        // decode body bytes to get a valid utf-8 encoded string, otherwise there are issues with special chars like in spanish
        final utf8String = utf8.decode(response.bodyBytes);

        final Map<String, dynamic> responseJson =
            jsonDecode(utf8String) as Map<String, dynamic>;

        return DeeplUsage(
          responseJson['character_count'] as int,
          responseJson['character_limit'] as int,
        );
      } else {
        // TODO: log something
      }
    } catch (e) {
      // TODO logger
    }
    return null;
  }
}

@immutable
class DeeplUsage extends Usage {
  final int _usedChars;
  final int _availableChars;

  const DeeplUsage(this._usedChars, this._availableChars)
      : super(_usedChars, _availableChars);

  @override
  String toString() {
    return 'DeeplUsage(usedChars: $_usedChars, availableChars: $_availableChars)';
  }
}
