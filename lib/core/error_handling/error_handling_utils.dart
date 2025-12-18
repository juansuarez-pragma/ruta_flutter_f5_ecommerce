import 'dart:convert';
import 'app_exceptions.dart';
import 'error_logger.dart';

/// Utilities for safely executing operations that may fail.
/// Provides type-safe wrappers for conversions and risky operations.

/// Safely runs an async function, capturing and converting exceptions.
///
/// If the function throws:
/// - If it's an [AppException], it is rethrown unchanged
/// - If it's another [Exception], it is converted to [UnknownException]
/// - If logging fails, execution continues (logging is non-critical)
///
/// Example:
/// ```dart
/// final user = await safeCall(
///   () => userRepository.getUser(id),
///   context: {'userId': id, 'operation': 'fetchUser'},
/// );
/// ```
Future<T> safeCall<T>(
  Future<T> Function() asyncFunction, {
  Map<String, dynamic>? context,
  String? operationName,
}) async {
  try {
    return await asyncFunction();
  } on AppException {
    // Already an AppException: rethrow unchanged.
    rethrow;
  } catch (e, st) {
    // Convert any other exception to UnknownException.
    final errorContext = {
      ...(context ?? {}),
      if (operationName != null) 'operation': operationName,
      'exceptionType': e.runtimeType.toString(),
    };

    final exception = UnknownException(
      message:
          'Error during operation${operationName != null ? ': $operationName' : ''}',
      originalException: e is Exception ? e : Exception(e.toString()),
    );

    // Log without crashing if logging fails.
    ErrorLogger().logAppException(
      exception,
      context: errorContext,
      stackTrace: st,
    );

    throw exception;
  }
}

/// Safely decodes JSON, capturing format errors.
///
/// Throws [ParseException] if the JSON is invalid, including the failed value.
///
/// Ejemplo:
/// ```dart
/// final data = safeJsonDecode(jsonString) as Map<String, dynamic>;
/// final items = safeJsonDecode(jsonArray) as List<dynamic>;
/// ```
T safeJsonDecode<T>(String jsonString) {
  try {
    return json.decode(jsonString) as T;
  } on FormatException catch (e, st) {
    // Capture a format-specific error.
    final exception = ParseException(
      message: 'Failed to decode JSON: ${e.message}',
      failedValue: jsonString.length > 200
          ? '${jsonString.substring(0, 200)}...'
          : jsonString,
      originalException: e,
    );

    ErrorLogger().logAppException(
      exception,
      context: {
        'jsonLength': jsonString.length,
        'operation': 'safeJsonDecode',
      },
      stackTrace: st,
    );

    throw exception;
  } catch (e, st) {
    // Any other exception during JSON decoding.
    final exception = ParseException(
      message: 'Unexpected error while decoding JSON',
      failedValue: jsonString.length > 200
          ? '${jsonString.substring(0, 200)}...'
          : jsonString,
      originalException: e is Exception ? e : Exception(e.toString()),
    );

    ErrorLogger().logAppException(
      exception,
      context: {
        'exceptionType': e.runtimeType.toString(),
        'operation': 'safeJsonDecode',
      },
      stackTrace: st,
    );

    throw exception;
  }
}

/// Safely executes a list operation, capturing lookup errors.
///
/// Nota: no captura subclases de [Error] (ej: `StateError`). Para búsquedas
/// típicas de "elemento no encontrado", usa [safeListFirstWhere] para evitar
/// lanzar `StateError` y retornar `null` o un fallback.
///
/// Ejemplo:
/// ```dart
/// // Sin fallback - lanza excepción si no existe
/// final user = safeListOperation(
///   () => users.firstWhere((u) => u.id == id),
/// );
///
/// // Con fallback - retorna valor por defecto
/// final user = safeListOperation(
///   () => users.firstWhere(
///     (u) => u.id == id,
///     orElse: () => User.empty(),
///   ),
/// );
/// ```
T safeListOperation<T>(
  T Function() operation, {
  Map<String, dynamic>? context,
  String? operationName,
}) {
  try {
    return operation();
  } on Exception catch (e, st) {
    // Unexpected exception.
    final exception = ParseException(
      message: 'Error inesperado en operación de lista',
      originalException: e,
    );

    ErrorLogger().logAppException(
      exception,
      context: {
        ...(context ?? {}),
        if (operationName != null) 'operation': operationName,
        'exceptionType': e.runtimeType.toString(),
      },
      stackTrace: st,
    );

    throw exception;
  }
}

/// Extensión de helper para usar safeListOperation con Iterable.
/// Proporciona alternativa a firstWhere.
///
/// Ejemplo:
/// ```dart
/// final user = safeListFirstWhere(
///   users,
///   (u) => u.id == id,
///   orElse: () => User.empty(),
/// );
/// ```
T? safeListFirstWhere<T>(
  Iterable<T> iterable,
  bool Function(T) test, {
  T Function()? orElse,
  Map<String, dynamic>? context,
}) {
  try {
    for (final item in iterable) {
      if (test(item)) return item;
    }
    return orElse?.call();
  } on Exception catch (e, st) {
    final exception = ParseException(
      message: 'Error inesperado en operación de lista',
      originalException: e,
    );

    ErrorLogger().logAppException(
      exception,
      context: {
        ...(context ?? {}),
        'operation': 'firstWhere',
        'exceptionType': e.runtimeType.toString(),
      },
      stackTrace: st,
    );

    throw exception;
  }
}

/// Helpers para manejo seguro de conversiones de tipo
extension SafeJsonConversion on String {
  /// Decodifica string JSON con manejo de error seguro
  T? tryDecodeJson<T>() {
    try {
      return safeJsonDecode(this) as T;
    } on ParseException {
      return null;
    }
  }

  /// Decodifica o retorna valor por defecto
  T decodeJsonOrDefault<T>(T defaultValue) {
    return tryDecodeJson<T>() ?? defaultValue;
  }
}
