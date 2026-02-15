import 'dart:developer' as developer;

/// Simple logging utility for the app
/// 
/// This provides a wrapper around dart:developer's log function
/// to avoid using print statements in production code.
class AppLogger {
  final String name;

  const AppLogger(this.name);

  /// Log a debug message
  void d(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: name,
      error: error,
      stackTrace: stackTrace,
      level: 500, // Level.FINE
    );
  }

  /// Log an error message
  void e(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: name,
      error: error,
      stackTrace: stackTrace,
      level: 1000, // Level.SEVERE
    );
  }

  /// Log an info message
  void i(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: name,
      error: error,
      stackTrace: stackTrace,
      level: 800, // Level.INFO
    );
  }

  /// Log a warning message
  void w(String message, {Object? error, StackTrace? stackTrace}) {
    developer.log(
      message,
      name: name,
      error: error,
      stackTrace: stackTrace,
      level: 900, // Level.WARNING
    );
  }
}
