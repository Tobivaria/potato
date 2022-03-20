import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:potato/file_handling/file_service.dart';
import 'package:potato/project/project_state_controller.dart';

class MockFileService extends Mock implements FileService {}

class MockLogger extends Mock implements Logger {}

class MockProjectStateController extends Mock implements ProjectStateController {}
