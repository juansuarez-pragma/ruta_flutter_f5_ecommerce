import 'package:equatable/equatable.dart';

/// Clase base para todas las excepciones de aplicación tipadas.
/// Proporciona estructura consistente para manejo de errores.
abstract class AppException extends Equatable implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.originalException,
  });

  /// Código único de error para identificación en logs y UI
  final String code;

  /// Mensaje técnico de error
  final String message;

  /// Excepción original capturada (si aplica)
  final Exception? originalException;

  /// Retorna mensaje amigable para mostrar al usuario.
  /// Traduce mensajes técnicos a lenguaje natural.
  String toUserMessage();

  /// Serializa la excepción para logging
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'originalException': originalException?.toString(),
    };
  }

  @override
  String toString() => 'AppException($code): $message';

  @override
  List<Object?> get props => [code, message, originalException];
}

/// Excepción para errores de parseo JSON o serialización
class ParseException extends AppException {
  const ParseException({
    required super.message,
    this.failedValue,
    super.originalException,
  }) : super(code: 'PARSE_ERROR');

  /// Valor que falló al parsear
  final String? failedValue;

  @override
  String toUserMessage() {
    return 'Disculpa, hubo un problema al procesar los datos. '
        'Por favor intenta de nuevo.';
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['failedValue'] = failedValue;
    return map;
  }

  @override
  List<Object?> get props => [...super.props, failedValue];
}

/// Excepción para errores de red o conectividad
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    this.statusCode,
    super.originalException,
  }) : super(code: 'NETWORK_ERROR');

  /// Código de estado HTTP (si aplica)
  final int? statusCode;

  @override
  String toUserMessage() {
    if (statusCode == 404) {
      return 'El recurso solicitado no fue encontrado.';
    }
    if (statusCode != null && statusCode! >= 500) {
      return 'Error en el servidor. Por favor intenta más tarde.';
    }
    return 'Problema de conexión a internet. Por favor verifica tu conexión '
        'y intenta de nuevo.';
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['statusCode'] = statusCode;
    return map;
  }

  @override
  List<Object?> get props => [...super.props, statusCode];
}

/// Excepción para errores de validación de datos
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    this.field,
    super.originalException,
  }) : super(code: 'VALIDATION_ERROR');

  /// Campo específico que falló validación
  final String? field;

  @override
  String toUserMessage() {
    if (field != null) {
      return 'Por favor verifica el campo "$field" e intenta de nuevo.';
    }
    return 'Algunos datos no son válidos. Por favor verifica e intenta de nuevo.';
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['field'] = field;
    return map;
  }

  @override
  List<Object?> get props => [...super.props, field];
}

/// Excepción para errores de almacenamiento local
class StorageException extends AppException {
  const StorageException({
    required super.message,
    this.operation,
    super.originalException,
  }) : super(code: 'STORAGE_ERROR');

  /// Operación que falló (read, write, delete)
  final String? operation;

  @override
  String toUserMessage() {
    return 'No pudimos acceder a la información almacenada. '
        'Por favor intenta de nuevo.';
  }

  @override
  Map<String, dynamic> toMap() {
    final map = super.toMap();
    map['operation'] = operation;
    return map;
  }

  @override
  List<Object?> get props => [...super.props, operation];
}

/// Excepción para errores desconocidos o inesperados
class UnknownException extends AppException {
  const UnknownException({
    required super.message,
    super.originalException,
  }) : super(code: 'UNKNOWN_ERROR');

  @override
  String toUserMessage() {
    return 'Ocurrió un error inesperado. Por favor intenta de nuevo.';
  }
}
