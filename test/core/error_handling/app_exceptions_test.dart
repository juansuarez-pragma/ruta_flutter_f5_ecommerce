import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/core/error_handling/app_exceptions.dart';

void main() {
  group('AppException Base Class', () {
    test('is comparable with Equatable', () {
      // Arrange - use UnknownException as a concrete implementation
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

    test('has a unique error code', () {
      // Arrange
      const parseEx = ParseException(message: 'Parse error');
      const unknownEx = UnknownException(message: 'Unknown error');

      // Assert
      expect(parseEx.code, equals('PARSE_ERROR'));
      expect(unknownEx.code, equals('UNKNOWN_ERROR'));
    });

    test('supports an optional originalException', () {
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

    test('has an informative toString()', () {
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
    test('creates ParseException with parsing details', () {
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

    test('toUserMessage() is user friendly', () {
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

    test('compares ParseExceptions correctly', () {
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

  group('UnknownException', () {
    test('creates UnknownException', () {
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

    test('toUserMessage() is generic', () {
      // Arrange
      const exception = UnknownException(
        message: 'Unexpected error in feature X',
      );

      // Act
      final userMessage = exception.toUserMessage();

      // Assert
      expect(userMessage, isNotEmpty);
      final containsExpectedText = userMessage
              .toLowerCase()
              .contains('unexpected') ||
          userMessage.toLowerCase().contains('error');
      expect(containsExpectedText, isTrue);
    });
  });

  group('toUserMessage() translations', () {
    test('hides technical details in user messages', () {
      // Arrange
      const parseException = ParseException(message: 'Invalid JSON');

      // Act
      final parseMsg = parseException.toUserMessage();

      // Assert - messages should be readable
      expect(parseMsg, isNotEmpty);
      // Should not leak raw technical wording
      expect(parseMsg, isNot(contains('FormatException')));
    });

    test('is consistent in format', () {
      // Arrange
      const exception1 = ParseException(message: 'Error 1');
      const exception2 = ParseException(message: 'Error 2');

      // Act
      final msg1 = exception1.toUserMessage();
      final msg2 = exception2.toUserMessage();

      // Assert
      expect(msg1, isNotEmpty);
      expect(msg2, isNotEmpty);
    });
  });

  group('Exception Serialization', () {
    test('serializes ParseException for logging', () {
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
  });

  group('Exception Wrapping', () {
    test('allows wrapping original exceptions', () {
      // Arrange
      const formatException = FormatException('Bad format');
      const wrapped = ParseException(
        message: 'Failed to parse JSON',
        originalException: formatException,
      );

      // Assert
      expect(wrapped.originalException, equals(formatException));
    });

    test('preserves original exception when wrapping', () {
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
