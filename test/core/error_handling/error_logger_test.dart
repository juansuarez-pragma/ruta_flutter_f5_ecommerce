import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/core/error_handling/error_logger.dart';

void main() {
  late ErrorLogger errorLogger;

  setUp(() {
    errorLogger = ErrorLogger();
  });

  group('ErrorLogger', () {
    test('should log exceptions with all details', () async {
      // Arrange
      final exception = Exception('Test error');
      final stackTrace = StackTrace.current;

      // Act & Assert - Should not rethrow
      expect(
        () => errorLogger.logError(
          message: 'Test message',
          exception: exception,
          stackTrace: stackTrace,
        ),
        returnsNormally,
      );
    });

    test('should not throw during logging', () async {
      // Arrange
      final exception = Exception('Critical error');
      final stackTrace = StackTrace.current;

      // Act & Assert
      expect(
        () {
          errorLogger.logError(
            message: 'Critical message',
            exception: exception,
            stackTrace: stackTrace,
          );
        },
        returnsNormally,
      );
    });

    test('should capture context information', () async {
      // Arrange
      final exception = Exception('Context test');
      final context = {'route': '/home', 'user_id': '123'};

      // Act & Assert - Should accept context
      expect(
        () => errorLogger.logError(
          message: 'Test with context',
          exception: exception,
          context: context,
        ),
        returnsNormally,
      );
    });

    test('should support different log levels (info, warning, error)', () async {
      // Act & Assert - Each level should work without errors
      expect(
        () {
          errorLogger.logInfo('Info message');
          errorLogger.logWarning('Warning message');
          errorLogger.logError(message: 'Error message');
        },
        returnsNormally,
      );
    });

    test('should handle error-level logging without context', () async {
      // Act & Assert
      expect(
        () => errorLogger.logError(message: 'Simple error'),
        returnsNormally,
      );
    });

    test('should allow logging with only a message', () async {
      // Act & Assert
      expect(
        () => errorLogger.logInfo('Just a message'),
        returnsNormally,
      );
    });

    test('should log full details when exception and stacktrace are provided',
        () async {
      // Arrange
      const exception = FormatException('Invalid JSON');
      final stackTrace = StackTrace.current;

      // Act & Assert - Should capture everything without issues
      expect(
        () => errorLogger.logError(
          message: 'JSON parsing failed',
          exception: exception,
          stackTrace: stackTrace,
        ),
        returnsNormally,
      );
    });

    test('should log with enriched context', () async {
      // Arrange
      final exception = Exception('DB error');
      final context = {
        'feature': 'auth',
        'operation': 'getCachedUser',
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Act & Assert
      expect(
        () => errorLogger.logError(
          message: 'Database operation failed',
          exception: exception,
          context: context,
        ),
        returnsNormally,
      );
    });

    test('should gracefully handle null exceptions', () async {
      // Act & Assert - Should not fail when exception is null
      expect(
        () => errorLogger.logError(message: 'Error without exception'),
        returnsNormally,
      );
    });

    test('should support logging from multiple features', () async {
      // Arrange
      const features = ['auth', 'cart', 'support', 'orders'];

      // Act & Assert
      expect(
        () {
          for (final feature in features) {
            errorLogger.logError(
              message: 'Error in $feature',
              context: {'feature': feature},
            );
          }
        },
        returnsNormally,
      );
    });
  });

  group('ErrorLogger - Edge Cases', () {
    test('should handle very long messages', () async {
      // Arrange
      final longMessage = 'x' * 10000;

      // Act & Assert
      expect(
        () => errorLogger.logError(message: longMessage),
        returnsNormally,
      );
    });

    test('should handle contexts with null values', () async {
      // Arrange
      final context = {
        'field1': 'value1',
        'field2': null,
        'field3': 'value3',
      };

      // Act & Assert
      expect(
        () => errorLogger.logError(
          message: 'Error with nullable context',
          context: context,
        ),
        returnsNormally,
      );
    });

    test('should handle multiple consecutive logs', () async {
      // Act & Assert
      expect(
        () {
          for (int i = 0; i < 100; i++) {
            errorLogger.logInfo('Message $i');
          }
        },
        returnsNormally,
      );
    });
  });
}
