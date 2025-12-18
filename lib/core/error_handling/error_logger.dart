import 'dart:developer' as developer;
import 'app_exceptions.dart';

/// Nivel de severidad de log
enum LogLevel { info, warning, error }

/// Servicio centralizado para logging de errores.
/// Singleton que captura y registra excepciones en toda la aplicación.
class ErrorLogger {
  factory ErrorLogger() => _instance;

  ErrorLogger._internal();

  static final ErrorLogger _instance = ErrorLogger._internal();

  /// Loguea un error con todos los detalles disponibles.
  ///
  /// Parámetros:
  /// - [message]: Mensaje descriptivo del error
  /// - [exception]: Excepción capturada (opcional)
  /// - [stackTrace]: Stack trace para debugging (opcional)
  /// - [context]: Información contextual adicional (opcional)
  /// - [level]: Nivel de severidad (default: error)
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

      // En producción, aquí se enviaría a Sentry/Firebase
      // _reportToMonitoringService(logMessage);
    } catch (_) {
      // Never throw during logging
    }
  }

  /// Loguea un mensaje informativo.
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

  /// Loguea una advertencia.
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

  /// Loguea una AppException con detalles tipados.
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

  /// Formatea el mensaje de log de forma legible
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

  /// Convierte LogLevel a int para developer.log
  int _logLevelToInt(LogLevel level) {
    return switch (level) {
      LogLevel.info => 0,
      LogLevel.warning => 1,
      LogLevel.error => 2,
    };
  }

  // En futuro, implementar envío a servicio de monitoreo
  // void _reportToMonitoringService(String logMessage) {
  //   // Sentry.captureException(exception, stackTrace: stackTrace);
  //   // FirebaseAnalytics.instance.logEvent(name: 'error_logged', parameters: {...});
  // }
}
