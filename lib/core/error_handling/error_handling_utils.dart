import 'dart:convert';
import 'app_exceptions.dart';
import 'error_logger.dart';

/// Utilidades para manejo seguro de operaciones que pueden fallar.
/// Proporciona wrappers type-safe para conversiones y operaciones riesgosas.

/// Ejecuta una función async de forma segura, capturando y convirtiendo excepciones.
///
/// Si la función lanza una excepción:
/// - Si es [AppException], se re-lanza sin modificar
/// - Si es otra [Exception], se convierte a [UnknownException]
/// - Si ocurre error al loguear, continúa (logging es no-crítico)
///
/// Ejemplo:
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
    // Si ya es AppException, re-lanzar sin modificar
    rethrow;
  } catch (e, st) {
    // Convertir cualquier otra excepción a UnknownException
    final errorContext = {
      ...(context ?? {}),
      if (operationName != null) 'operation': operationName,
      'exceptionType': e.runtimeType.toString(),
    };

    final exception = UnknownException(
      message: 'Error durante operación${operationName != null ? ': $operationName' : ''}',
      originalException: e is Exception ? e : Exception(e.toString()),
    );

    // Loguear sin relanzar si falla el logging
    ErrorLogger().logAppException(
      exception,
      context: errorContext,
      stackTrace: st,
    );

    throw exception;
  }
}

/// Decodifica JSON de forma segura, capturando errores de formato.
///
/// Lanza [ParseException] si el JSON es inválido, con detalles del valor fallido.
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
    // Capturar error de formato específico
    final exception = ParseException(
      message: 'Error al decodificar JSON: ${e.message}',
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
    // Cualquier otra excepción durante JSON decode
    final exception = ParseException(
      message: 'Error inesperado al decodificar JSON',
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

/// Ejecuta una operación de lista de forma segura, capturando errores de búsqueda.
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
    // Otra excepción inesperada
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
