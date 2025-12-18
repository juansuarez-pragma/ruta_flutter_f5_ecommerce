import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/core/error_handling/app_exceptions.dart';

void main() {
  group('AppException Base Class', () {
    test('debe ser comparable con Equatable', () {
      // Arrange - usar UnknownException como implementación concreta
      const exception1 = UnknownException(
        message: 'Test message',
      );
      const exception2 = UnknownException(
        message: 'Test message',
      );
      const exception3 = UnknownException(
        message: 'Different message',
      );

      // Assert
      expect(exception1, equals(exception2));
      expect(exception1, isNot(equals(exception3)));
    });

    test('debe tener código identificador único', () {
      // Arrange
      const parseEx = ParseException(message: 'Parse error');
      const networkEx = NetworkException(message: 'Network error');
      const validationEx = ValidationException(
        message: 'Validation error',
        field: 'email',
      );
      const storageEx = StorageException(message: 'Storage error');

      // Assert
      expect(parseEx.code, equals('PARSE_ERROR'));
      expect(networkEx.code, equals('NETWORK_ERROR'));
      expect(validationEx.code, equals('VALIDATION_ERROR'));
      expect(storageEx.code, equals('STORAGE_ERROR'));
    });

    test('debe soportar originalException opcional', () {
      // Arrange
      final originalError = Exception('Original error');

      // Act
      final exception = UnknownException(
        message: 'Error wrapped',
        originalException: originalError,
      );

      // Assert
      expect(exception.originalException, equals(originalError));
    });

    test('debe tener toString() informativo', () {
      // Arrange
      const exception = UnknownException(
        message: 'Error message',
      );

      // Act
      final stringValue = exception.toString();

      // Assert
      expect(stringValue, contains('UNKNOWN_ERROR'));
      expect(stringValue, contains('Error message'));
    });
  });

  group('ParseException', () {
    test('debe crear ParseException con detalles de parseo', () {
      // Act
      const exception = ParseException(
        message: 'Invalid JSON format',
        failedValue: '{"invalid: json}',
      );

      // Assert
      expect(exception.code, equals('PARSE_ERROR'));
      expect(exception.message, equals('Invalid JSON format'));
      expect(exception.failedValue, equals('{"invalid: json}'));
    });

    test('debe tener toUserMessage() amigable', () {
      // Arrange
      const exception = ParseException(
        message: 'FormatException: Unexpected character',
      );

      // Act
      final userMessage = exception.toUserMessage();

      // Assert
      expect(userMessage, isNotEmpty);
      expect(userMessage, isNot(contains('FormatException')));
    });

    test('debe comparar ParseExceptions correctamente', () {
      // Arrange
      const exception1 = ParseException(
        message: 'Parse error',
        failedValue: 'value1',
      );
      const exception2 = ParseException(
        message: 'Parse error',
        failedValue: 'value1',
      );
      const exception3 = ParseException(
        message: 'Parse error',
        failedValue: 'value2',
      );

      // Assert
      expect(exception1, equals(exception2));
      expect(exception1, isNot(equals(exception3)));
    });
  });

  group('NetworkException', () {
    test('debe crear NetworkException', () {
      // Act
      const exception = NetworkException(
        message: 'Connection timeout',
        statusCode: 504,
      );

      // Assert
      expect(exception.code, equals('NETWORK_ERROR'));
      expect(exception.statusCode, equals(504));
    });

    test('debe tener toUserMessage() para errores de red', () {
      // Arrange
      const exception = NetworkException(message: 'No internet connection');

      // Act
      final userMessage = exception.toUserMessage();

      // Assert
      final containsExpectedText = userMessage.toLowerCase().contains('conexión') ||
          userMessage.toLowerCase().contains('red') ||
          userMessage.toLowerCase().contains('internet');
      expect(containsExpectedText, isTrue);
    });

    test('debe diferenciar tipos de error de red', () {
      // Arrange
      const timeoutException = NetworkException(
        message: 'Request timeout',
        statusCode: 504,
      );
      const notFoundException = NetworkException(
        message: 'Resource not found',
        statusCode: 404,
      );

      // Assert
      expect(timeoutException.code, equals('NETWORK_ERROR'));
      expect(notFoundException.code, equals('NETWORK_ERROR'));
      expect(timeoutException.statusCode, equals(504));
      expect(notFoundException.statusCode, equals(404));
    });
  });

  group('ValidationException', () {
    test('debe crear ValidationException', () {
      // Act
      const exception = ValidationException(
        message: 'Email is invalid',
        field: 'email',
      );

      // Assert
      expect(exception.code, equals('VALIDATION_ERROR'));
      expect(exception.field, equals('email'));
    });

    test('debe tener toUserMessage() descriptivo', () {
      // Arrange
      const exception = ValidationException(
        message: 'Password too short',
        field: 'password',
      );

      // Act
      final userMessage = exception.toUserMessage();

      // Assert
      expect(userMessage, isNotEmpty);
      final containsExpectedText = userMessage.toLowerCase().contains('contraseña') ||
          userMessage.toLowerCase().contains('password');
      expect(containsExpectedText, isTrue);
    });

    test('debe comparar ValidationExceptions correctamente', () {
      // Arrange
      const exception1 = ValidationException(
        message: 'Invalid input',
        field: 'name',
      );
      const exception2 = ValidationException(
        message: 'Invalid input',
        field: 'name',
      );
      const exception3 = ValidationException(
        message: 'Invalid input',
        field: 'email',
      );

      // Assert
      expect(exception1, equals(exception2));
      expect(exception1, isNot(equals(exception3)));
    });
  });

  group('StorageException', () {
    test('debe crear StorageException', () {
      // Act
      const exception = StorageException(
        message: 'Failed to read from storage',
        operation: 'read',
      );

      // Assert
      expect(exception.code, equals('STORAGE_ERROR'));
      expect(exception.operation, equals('read'));
    });

    test('debe tener toUserMessage() amigable', () {
      // Arrange
      const exception = StorageException(
        message: 'SharedPreferences error',
        operation: 'write',
      );

      // Act
      final userMessage = exception.toUserMessage();

      // Assert
      expect(userMessage, isNotEmpty);
      expect(userMessage, isNot(contains('SharedPreferences')));
    });
  });

  group('UnknownException', () {
    test('debe crear UnknownException', () {
      // Arrange
      final originalError = Exception('Unknown error');

      // Act
      final exception = UnknownException(
        message: 'An unexpected error occurred',
        originalException: originalError,
      );

      // Assert
      expect(exception.code, equals('UNKNOWN_ERROR'));
      expect(exception.originalException, equals(originalError));
    });

    test('debe tener toUserMessage() genérico', () {
      // Arrange
      const exception = UnknownException(
        message: 'Unexpected error in feature X',
      );

      // Act
      final userMessage = exception.toUserMessage();

      // Assert
      expect(userMessage, isNotEmpty);
      final containsExpectedText = userMessage.toLowerCase().contains('inesperado') ||
          userMessage.toLowerCase().contains('unexpected');
      expect(containsExpectedText, isTrue);
    });
  });

  group('toUserMessage() translations', () {
    test('debe traducir mensajes técnicos a español amigable', () {
      // Arrange
      const parseException = ParseException(message: 'Invalid JSON');
      const networkException = NetworkException(message: 'Connection error');
      const validationException = ValidationException(
        message: 'Invalid input',
        field: 'email',
      );

      // Act
      final parseMsg = parseException.toUserMessage();
      final networkMsg = networkException.toUserMessage();
      final validationMsg = validationException.toUserMessage();

      // Assert - Mensajes deben ser legibles
      expect(parseMsg, isNotEmpty);
      expect(networkMsg, isNotEmpty);
      expect(validationMsg, isNotEmpty);
      // No deben contener palabras técnicas crudas
      expect(parseMsg, isNot(contains('FormatException')));
      expect(networkMsg, isNot(contains('IOException')));
    });

    test('debe ser consistente en formato', () {
      // Arrange
      const exception1 = ParseException(message: 'Error 1');
      const exception2 = ParseException(message: 'Error 2');

      // Act
      final msg1 = exception1.toUserMessage();
      final msg2 = exception2.toUserMessage();

      // Assert - Ambos deben ser strings, no null
      expect(msg1, isNotEmpty);
      expect(msg2, isNotEmpty);
    });
  });

  group('Exception Serialization', () {
    test('debe serializar ParseException para logging', () {
      // Arrange
      const exception = ParseException(
        message: 'JSON parse error',
        failedValue: '{"bad json"}',
      );

      // Act
      final serialized = exception.toMap();

      // Assert
      expect(serialized['code'], equals('PARSE_ERROR'));
      expect(serialized['message'], equals('JSON parse error'));
      expect(serialized['failedValue'], equals('{"bad json"}'));
    });

    test('debe serializar NetworkException para logging', () {
      // Arrange
      const exception = NetworkException(
        message: 'Server error',
        statusCode: 500,
      );

      // Act
      final serialized = exception.toMap();

      // Assert
      expect(serialized['code'], equals('NETWORK_ERROR'));
      expect(serialized['statusCode'], equals(500));
    });

    test('debe serializar ValidationException para logging', () {
      // Arrange
      const exception = ValidationException(
        message: 'Invalid email',
        field: 'email',
      );

      // Act
      final serialized = exception.toMap();

      // Assert
      expect(serialized['code'], equals('VALIDATION_ERROR'));
      expect(serialized['field'], equals('email'));
    });
  });

  group('Exception Wrapping', () {
    test('debe permitir envolver excepciones originales', () {
      // Arrange
      const formatException = FormatException('Bad format');
      const wrapped = ParseException(
        message: 'Failed to parse JSON',
        originalException: formatException,
      );

      // Assert
      expect(wrapped.originalException, equals(formatException));
    });

    test('debe preservar stacktrace cuando se envuelve', () {
      // Arrange
      try {
        throw Exception('Original error');
      } catch (e) {
        // Act
        final wrapped = UnknownException(
          message: 'Error wrapped',
          originalException: e as Exception?,
        );

        // Assert
        expect(wrapped.originalException, isNotNull);
      }
    });
  });
}
