import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:potato/project/project_controller.dart';

class MockLogger extends Mock implements Logger {}

class MockProjectController extends Mock implements ProjectController {}
