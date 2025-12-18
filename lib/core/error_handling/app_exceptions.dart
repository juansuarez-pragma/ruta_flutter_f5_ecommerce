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
