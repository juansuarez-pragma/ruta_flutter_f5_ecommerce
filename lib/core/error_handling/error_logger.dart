import 'dart:developer' as developer;
import 'app_exceptions.dart';

/// Log severity level.
enum LogLevel { info, warning, error }

/// Centralized error logging service.
/// Singleton that captures and logs exceptions across the whole app.
class ErrorLogger {
  factory ErrorLogger() => _instance;

  ErrorLogger._internal();

  static final ErrorLogger _instance = ErrorLogger._internal();

  /// Logs an error with all available details.
  ///
  /// Parameters:
  /// - [message]: Descriptive error message
  /// - [exception]: Captured exception (optional)
  /// - [stackTrace]: Stack trace for debugging (optional)
  /// - [context]: Additional contextual information (optional)
  /// - [level]: Severity level (default: error)
  void logError({
    required String message,
    Exception? exception,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
    LogLevel level = LogLevel.error,
  }) {
    try {
      final timestamp = DateTime.now().toIso8601String();
      final logMessage = _formatLogMessage(
        message: message,
        exception: exception,
        stackTrace: stackTrace,
        context: context,
        timestamp: timestamp,
        level: level,
      );

      // Log a developer console
      developer.log(
        logMessage,
        name: 'ErrorLogger',
        level: _logLevelToInt(level),
        error: exception,
        stackTrace: stackTrace,
      );

      // In production, report to Sentry/Firebase here.
      // _reportToMonitoringService(logMessage);
    } catch (_) {
      // Never throw during logging
    }
  }

  /// Logs an informational message.
  void logInfo(
    String message, {
    Map<String, dynamic>? context,
  }) {
    logError(
      message: message,
      context: context,
      level: LogLevel.info,
    );
  }

  /// Logs a warning.
  void logWarning(
    String message, {
    Exception? exception,
    Map<String, dynamic>? context,
  }) {
    logError(
      message: message,
      exception: exception,
      context: context,
      level: LogLevel.warning,
    );
  }

  /// Logs an AppException with typed details.
  void logAppException(
    AppException exception, {
    String? additionalContext,
    Map<String, dynamic>? context,
    StackTrace? stackTrace,
  }) {
    final enrichedContext = {
      ...(context ?? {}),
      'exceptionCode': exception.code,
      'exceptionType': exception.runtimeType.toString(),
      if (additionalContext != null) 'additionalContext': additionalContext,
      ...exception.toMap(),
    };

    logError(
      message: exception.message,
      exception: exception.originalException,
      context: enrichedContext,
      stackTrace: stackTrace,
    );
  }

  /// Formats the log message for readability.
  String _formatLogMessage({
    required String message,
    Exception? exception,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
    required String timestamp,
    required LogLevel level,
  }) {
    final buffer = StringBuffer();

    buffer.writeln('[$timestamp] [${level.name.toUpperCase()}]');
    buffer.writeln('Message: $message');

    if (exception != null) {
      buffer.writeln('Exception: ${exception.runtimeType.toString()}');
      buffer.writeln('Details: ${exception.toString()}');
    }

    if (context != null && context.isNotEmpty) {
      buffer.writeln('Context:');
      context.forEach((key, value) {
        buffer.writeln('  $key: $value');
      });
    }

    if (stackTrace != null) {
      buffer.writeln('StackTrace:');
      buffer.writeln(stackTrace.toString());
    }

    return buffer.toString();
  }

  /// Converts LogLevel to an int for developer.log.
  int _logLevelToInt(LogLevel level) {
    return switch (level) {
      LogLevel.info => 0,
      LogLevel.warning => 1,
      LogLevel.error => 2,
    };
  }

  // TODO: implement reporting to a monitoring service.
  // void _reportToMonitoringService(String logMessage) {
  //   // Sentry.captureException(exception, stackTrace: stackTrace);
  //   // FirebaseAnalytics.instance.logEvent(name: 'error_logged', parameters: {...});
  // }
}
