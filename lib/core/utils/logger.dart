import 'dart:developer' as dev;

class AppLogger {
  static void log(String message, [Object? error, StackTrace? stackTrace]) {
    dev.log(
      message,
      time: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
      name: 'FitKarma',
    );
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    log('ERROR: $message', error, stackTrace);
  }

  static void info(String message) {
    log('INFO: $message');
  }
}
