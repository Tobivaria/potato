import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:potato/utils/potato_logger.dart';

final Provider<FileService> fileServiceProvider = Provider<FileService>((ProviderRef<FileService> ref) {
  return FileService(ref.watch(loggerProvider));
});

class FileService {
  final Logger _logger;
  final JsonEncoder _prettyEncoder = const JsonEncoder.withIndent('  ');

  FileService(this._logger);

  Future<List<Map<String, dynamic>>> readFilesFromDirectory(String projectPath) async {
    final Directory dir = Directory(projectPath);
    final List<FileSystemEntity> entities = await dir.list().toList(); // TODO error handling

    final List<Map<String, dynamic>> list = [];

    for (final item in entities) {
      final File file = File(item.path);
      final Map<String, dynamic>? tmp = await readJsonFromFile(file);
      if (tmp != null) {
        list.add(tmp);
      }
    }
    return list;
  }

  Future<Map<String, dynamic>?> readJsonFromFile(File file) async {
    final String raw = await file.readAsString();
    // TODO validate file format in calling method
    Map<String, dynamic>? data;
    try {
      data = jsonDecode(raw) as Map<String, dynamic>;
    } catch (e) {
      _logger.e(e, data);
    }
    return data;
  }

  Future<void> writeFile(File file, Map<String, dynamic> data) async {
    final String pretty = _prettyEncoder.convert(data);
    await file.writeAsString(pretty);
  }
}
