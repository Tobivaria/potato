import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:potato/project/project_controller.dart';
import 'package:potato/translation/arb_definition.dart';

import '../language/language.dart';
import '../potato_logger.dart';
import '../project/project.dart';

final AutoDisposeProvider<FileService> fileServiceProvider =
    Provider.autoDispose<FileService>((ProviderRef<FileService> ref) {
  return FileService(ref.watch(loggerProvider), ref.watch(projectProvider.notifier));
});

class FileService {
  FileService(this._logger, this._pController);

  final Logger _logger;
  final ProjectController _pController;

  final JsonEncoder prettyEncoder = const JsonEncoder.withIndent('  ');
  // read write append to file
  // format arb file (json)

  /// Returns local app storage
  Future<String?> get _localPath async {
    try {
      final Directory? directory = await getApplicationDocumentsDirectory();
      return directory?.path;
    } catch (e) {
      _logger.e('Error receving file path', e);
      return null;
    }
  }

  Future<bool> saveProject(String fileName, Project project) async {
    final String? path = await _localPath;

    if (path == null) {
      return false;
    }

    final Map<String, String> rawFormat = project.toMap();
    final String rawData = json.encode(rawFormat);
    final File file = File('$path/$fileName.potato');
    await file.writeAsString(rawData);

    return true;
  }

  // TODO error handling on loading, return enum
  void loadProject(File file) async {
    var data = await _loadJsonFromFile(file);
    if (data == null) {
      return;
    }
    final project = Project.fromSerialized(data);
    print(project.baseLanguage);
    print(project.path);

    // TODO search for arb files
    // load all arb files and their content
    if (project.path != null) {
      _fileList(project.path!, project.baseLanguage);
    }
  }

  Future<void> _fileList(String projectPath, String baseLanguage) async {
    final dir = Directory(projectPath);
    final List<FileSystemEntity> entities = await dir.list().toList();

    final List<File> files = [];
    File? baseFile;

    for (var item in entities) {
      File file = File(item.path);
      if (basename(item.path).contains('_$baseLanguage.arb')) {
        baseFile = File(item.path);
      } else {
        files.add(file);
      }
    }

    if (baseFile == null) {
      // TODO print error
      return;
    }

    Map<String, Language> languages = {};
    Map<String, ArbDefinition> arbDefinitions = {};

    Map<String, dynamic>? data = await _extractData(baseFile, extracArbData: true);
    if (data != null) {
      languages[baseLanguage] = Language(existingTranslations: data['data']);
      arbDefinitions = data['arb'];
    }
    for (var item in files) {
      Map<String, dynamic>? data = await _extractData(item);
      if (data != null) {
        languages[data['locale']] = Language(existingTranslations: data['data']);
      }
    }
    _pController.setProject(
      Project(
          baseLanguage: baseLanguage,
          path: projectPath,
          existingArdbDefinitions: arbDefinitions,
          existingLanguages: languages),
    );
  }

  Future<Map<String, dynamic>?> _extractData(File file, {bool extracArbData = false}) async {
    var data = await _loadJsonFromFile(file);
    if (data == null) {
      return null;
    }

    Map<String, String> translations = {};
    Map<String, ArbDefinition> arbDefinitions = {};
    String locale = '';
    for (var key in data.keys) {
      var item = data[key];
      if (key == '@@locale') {
        print("Processing language $item");
        locale = item;
      } else if (key.startsWith('@')) {
        arbDefinitions[key.substring(1)] = ArbDefinition.fromMap(item);
      } else {
        translations[key] = item;
      }
    }
    return {'data': translations, 'arb': arbDefinitions, 'locale': locale};
  }

  Future<Map<String, dynamic>?>? _loadJsonFromFile(File file) async {
    final String raw = await file.readAsString();
    // TODO validate file format
    Map<String, dynamic>? data;
    try {
      data = jsonDecode(raw);
    } catch (e) {
      _logger.e(e, data);
    }
    return data;
  }

  Future<void> exportLanguage(Project project) async {
    for (var item in project.languages.keys) {
      var data = project.exportLanguage(item);
      final File file = File('app_$item.arb');
      String pretty = prettyEncoder.convert(data);
      await file.writeAsString(pretty);
    }
  }
}
