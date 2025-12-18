import 'app_exceptions.dart';

/// Log severity level.
enum LogLevel { info, warning, error }

/// Abstraction for logging, to avoid hard dependencies on a specific logger.
abstract interface class AppLogger {
  void logError({
    required String message,
    Exception? exception,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
    LogLevel level,
  });

  void logInfo(String message, {Map<String, dynamic>? context});

  void logWarning(
    String message, {
    Exception? exception,
    Map<String, dynamic>? context,
  });

  void logAppException(
    AppException exception, {
    String? additionalContext,
    Map<String, dynamic>? context,
    StackTrace? stackTrace,
  });
}

