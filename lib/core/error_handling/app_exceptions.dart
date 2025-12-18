import 'package:equatable/equatable.dart';

/// Base class for all typed application exceptions.
/// Provides a consistent structure for error handling.
abstract class AppException extends Equatable implements Exception {
  const AppException({
    required this.code,
    required this.message,
    this.originalException,
  });

  /// Unique error code for logs and UI.
  final String code;

  /// Technical error message.
  final String message;

  /// Original exception (if any).
  final Exception? originalException;

  /// Returns a user-friendly message.
  String toUserMessage();

  /// Serializes the exception for logging.
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

/// Exception for JSON parsing/serialization errors.
class ParseException extends AppException {
  const ParseException({
    required super.message,
    this.failedValue,
    super.originalException,
  }) : super(code: 'PARSE_ERROR');

  /// Value that failed to parse.
  final String? failedValue;

  @override
  String toUserMessage() {
    return 'Sorry, there was a problem processing the data. '
        'Please try again.';
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

/// Exception for network/connectivity errors.
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    this.statusCode,
    super.originalException,
  }) : super(code: 'NETWORK_ERROR');

  /// HTTP status code (if applicable).
  final int? statusCode;

  @override
  String toUserMessage() {
    if (statusCode == 404) {
      return 'The requested resource was not found.';
    }
    if (statusCode != null && statusCode! >= 500) {
      return 'Server error. Please try again later.';
    }
    return 'Internet connection issue. Please check your connection '
        'and try again.';
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

/// Exception for data validation errors.
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    this.field,
    super.originalException,
  }) : super(code: 'VALIDATION_ERROR');

  /// Specific field that failed validation.
  final String? field;

  @override
  String toUserMessage() {
    if (field != null) {
      return 'Please check the "$field" field and try again.';
    }
    return 'Some data is invalid. Please review and try again.';
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

/// Exception for local storage errors.
class StorageException extends AppException {
  const StorageException({
    required super.message,
    this.operation,
    super.originalException,
  }) : super(code: 'STORAGE_ERROR');

  /// Operation that failed (read, write, delete).
  final String? operation;

  @override
  String toUserMessage() {
    return 'We could not access the stored information. '
        'Please try again.';
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

/// Exception for unknown/unexpected errors.
class UnknownException extends AppException {
  const UnknownException({
    required super.message,
    super.originalException,
  }) : super(code: 'UNKNOWN_ERROR');

  @override
  String toUserMessage() {
    return 'An unexpected error occurred. Please try again.';
  }
}
