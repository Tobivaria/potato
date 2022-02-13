import 'package:logger/logger.dart';
import 'package:riverpod/riverpod.dart';

final Provider<Logger> loggerProvider = Provider<Logger>((ProviderRef<Logger> ref) {
  return Logger();
});
