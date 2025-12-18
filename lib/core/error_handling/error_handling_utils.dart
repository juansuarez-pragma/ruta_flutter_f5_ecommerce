import 'dart:convert';
import 'app_exceptions.dart';

/// Utilities for safe JSON decoding and type conversion helpers.

/// Safely decodes JSON, capturing format errors.
///
/// Throws [ParseException] if the JSON is invalid, including the failed value.
///
/// Example:
/// ```dart
/// final data = safeJsonDecode(jsonString) as Map<String, dynamic>;
/// final items = safeJsonDecode(jsonArray) as List<dynamic>;
/// ```
T safeJsonDecode<T>(String jsonString) {
  try {
    return json.decode(jsonString) as T;
  } on FormatException catch (e) {
    // Capture a format-specific error.
    final exception = ParseException(
      message: 'Failed to decode JSON: ${e.message}',
      failedValue: jsonString.length > 200
          ? '${jsonString.substring(0, 200)}...'
          : jsonString,
      originalException: e,
    );

    throw exception;
  } catch (e) {
    // Any other exception during JSON decoding.
    final exception = ParseException(
      message: 'Unexpected error while decoding JSON',
      failedValue: jsonString.length > 200
          ? '${jsonString.substring(0, 200)}...'
          : jsonString,
      originalException: e is Exception ? e : Exception(e.toString()),
    );

    throw exception;
  }
}

/// Helpers for safely handling type conversions.
extension SafeJsonConversion on String {
  /// Decodes a JSON string with safe error handling.
  T? tryDecodeJson<T>() {
    try {
      return safeJsonDecode(this) as T;
    } on ParseException {
      return null;
    }
  }

  /// Decodes or returns a default value.
  T decodeJsonOrDefault<T>(T defaultValue) {
    return tryDecodeJson<T>() ?? defaultValue;
  }
}
