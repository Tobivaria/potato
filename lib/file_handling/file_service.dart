import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../potato_logger.dart';
import '../project/project.dart';

final AutoDisposeProvider<FileService> fileServiceProvider =
    Provider.autoDispose<FileService>((ProviderRef<FileService> ref) {
  return FileService(ref.watch(loggerProvider));
});

class FileService {
  FileService(this._logger);

  final Logger _logger;
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
    final String raw = await file.readAsString();
    // TODO validate file format
    Map<String, dynamic>? data;
    try {
      data = jsonDecode(raw);
    } catch (e) {
      _logger.e(e, data);
    }
    if (data == null) {
      return;
    }
    final project = Project.fromSerialized(data);
    print(project.baseLanaguage);
    print(project.path);

    // TODO search for arb files
    // load all arb files and their content
  }
}
