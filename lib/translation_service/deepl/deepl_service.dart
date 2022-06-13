import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:potato/settings/shared_preferences_repository.dart';
import 'package:potato/translation_service/fake_service.dart';
import 'package:potato/translation_service/translation_config.dart';
import 'package:potato/translation_service/translation_service.dart';
import 'package:potato/translation_service/usage.dart';

class DeeplService implements TranslationService {
  DeeplConfig deeplConfig;
  @override
  TranslationConfig translationConfig;
  @override
  Client client;
  final String _baseUrl = 'https://api-free.deepl.com/v2/';

  DeeplService(
    this.deeplConfig,
    this.translationConfig,
    this.client,
  );

  @override
  Future<String> translate(String toTranslate) async {
    final String preparedTranslation = replacePlaceholderWithTag(toTranslate);

    final Map<String, String> requestBody = <String, String>{
      'auth_key': deeplConfig.authKey,
      'text': preparedTranslation,
      'target_lang': translationConfig.targetLang,
      'source_Lang': translationConfig.sourceLang,
      'formality': 'less',
      'tag_handling': deeplConfig.tagHandling,
      'ignore_tags': deeplConfig.replacePlaceholderTag
    };

    final String url = '${_baseUrl}translate';
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
      out = out.replaceAll('{', '<${deeplConfig.replacePlaceholderTag}>');
      out = out.replaceAll('}', '</${deeplConfig.replacePlaceholderTag}>');
    }
    return out;
  }

  String replaceTagWithPlaceholder(String val) {
    String out = val;
    final RegExp regExp = RegExp('<p>.*</p>');
    // replace placeholder brackets with placeholder xml
    if (regExp.hasMatch(val)) {
      out = out.replaceAll('<${deeplConfig.replacePlaceholderTag}>', '{');
      out = out.replaceAll('</${deeplConfig.replacePlaceholderTag}>', '}');
    }
    return out;
  }

  @override
  Future<DeeplUsage?> getUsage() async {
    final String url = '${_baseUrl}usage';

    final Map<String, String> requestBody = <String, String>{
      'auth_key': deeplConfig.authKey
    };

    try {
      final Response response =
          await client.post(Uri.parse(url), body: requestBody);

      print(response);

      if (response.statusCode == 200) {
        // decode body bytes to get a valid utf-8 encoded string, otherwise there are issues with special chars like in spanish
        final utf8String = utf8.decode(response.bodyBytes);

        final Map<String, dynamic> responseJson =
            jsonDecode(utf8String) as Map<String, dynamic>;

        return DeeplUsage(
          responseJson['character_count'] as int,
          responseJson['character_limit'] as int,
        );
      }
    } catch (e) {
      // TODO logger
    }
    return null;
  }

  @override
  String getName() {
    return 'DeepL';
  }

  @override
  // TODO: implement fakeConfig
  FakeConfig get fakeConfig => throw UnimplementedError();

  @override
  Future<String> getApiKey() {
    // TODO: implement getApiKey
    throw UnimplementedError();
  }

  @override
  // TODO: implement preferencesRepository
  SharedPreferencesRepository get preferencesRepository =>
      throw UnimplementedError();

  @override
  Future<void> setApiKey(String val) {
    // TODO: implement setApiKey
    throw UnimplementedError();
  }

  @override
  // TODO: implement preferenceKey
  String get preferenceKey => throw UnimplementedError();
}

@immutable
class DeeplConfig {
  final String authKey;
  late final String tagHandling;

  /// tag which will replace placeholders in the request
  /// these tags are also ignored, and will not be translated
  late final String replacePlaceholderTag;

  DeeplConfig({
    required this.authKey,
  }) {
    tagHandling = 'xml';
    replacePlaceholderTag = 'p';
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
