import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:potato/utils/potato_logger.dart';

import '../mocks.dart';

class FakeFile extends Fake implements File {
  @override
  Future<FakeFile> writeAsString(
    String contents, {
    FileMode mode = FileMode.write,
    Encoding encoding = utf8,
    bool flush = false,
  }) async {
    return Future.value(FakeFile());
  }
}

void main() {
  late ProviderContainer container;
  late Logger mockLogger;

  setUp(() {
    mockLogger = MockLogger();
    container = ProviderContainer(
      overrides: [
        loggerProvider.overrideWithValue(mockLogger),
      ],
    );
  });

  // TODO implement
  test(
    'Read files in directory',
    () {
      // String path = File(r'.\test_data\testgroup\en\testgroup_en-CY.txt')
    },
    skip: true,
  );

  test(
    'Read json from file',
    () {
      // String path = File(r'.\test_data\testgroup\en\testgroup_en-CY.txt')
    },
    skip: true,
  );

  test(
    'Writing formatted json file',
    () {
      // String path = File(r'.\test_data\testgroup\en\testgroup_en-CY.txt')
    },
    skip: true,
  );
}
