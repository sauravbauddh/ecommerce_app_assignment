import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger(
  printer: PrettyPrinter(
    stackTraceBeginIndex: 4,
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);

Dispatcher _logHistory = Dispatcher("");

void log(String? value) {
  String v = value ?? "";
  _logHistory.value = "$v\n${_logHistory.value}";
  if (kReleaseMode == false) {
    logger.i(v);
  }
}

void logError(String? value) => logger.e("[ERROR] ${value ?? ""}");

void initLogger(VoidCallback runApp) {
  runZonedGuarded(() async {
    // WidgetsFlutterBinding.ensureInitialized();
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      logger.e(details.runtimeType,
          error: details.exception, stackTrace: details.stack);
    };
    runApp.call();
  }, (error, stacktrace) {
    String errorString = '';
    String stacktraceString = '';
    if (error != null) {
      errorString = error.toString();
    }
    if (stacktrace != null) {
      stacktraceString = stacktrace.toString();
    }
    print('error $errorString stacktrace $stacktraceString');
    logger.e('init failed', error: error, stackTrace: stacktrace);
  });
}

class Dispatcher extends ValueNotifier<String> {
  Dispatcher(super.value);
}
