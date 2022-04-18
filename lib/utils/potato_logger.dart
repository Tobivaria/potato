import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

final Provider<Logger> loggerProvider = Provider<Logger>((ProviderRef<Logger> ref) {
  return Logger();
});
