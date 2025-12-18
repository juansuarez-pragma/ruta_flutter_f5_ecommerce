import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/core/error_handling/error_logger.dart';

void main() {
  late ErrorLogger errorLogger;

  setUp(() {
    errorLogger = ErrorLogger();
  });

  group('ErrorLogger', () {
    test('debe loguear excepciones con todos los detalles', () async {
      // Arrange
      final exception = Exception('Test error');
      final stackTrace = StackTrace.current;

      // Act & Assert - No debe relanzar excepción
      expect(
        () => errorLogger.logError(
          message: 'Test message',
          exception: exception,
          stackTrace: stackTrace,
        ),
        returnsNormally,
      );
    });

    test('no debe relanzar excepciones durante logging', () async {
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

    test('debe capturar información del contexto', () async {
      // Arrange
      final exception = Exception('Context test');
      final context = {'route': '/home', 'user_id': '123'};

      // Act & Assert - Debe permitir contexto
      expect(
        () => errorLogger.logError(
          message: 'Test with context',
          exception: exception,
          context: context,
        ),
        returnsNormally,
      );
    });

    test('debe permitir diferentes niveles de log (info, warning, error)', () async {
      // Act & Assert - Cada nivel debe funcionar sin errores
      expect(
        () {
          errorLogger.logInfo('Info message');
          errorLogger.logWarning('Warning message');
          errorLogger.logError(message: 'Error message');
        },
        returnsNormally,
      );
    });

    test('debe responder a nivel de error sin contexto', () async {
      // Act & Assert
      expect(
        () => errorLogger.logError(message: 'Simple error'),
        returnsNormally,
      );
    });

    test('debe permitir logging con solo mensaje', () async {
      // Act & Assert
      expect(
        () => errorLogger.logInfo('Just a message'),
        returnsNormally,
      );
    });

    test('debe loguear detalles completos cuando exception y stacktrace están presentes',
        () async {
      // Arrange
      const exception = FormatException('Invalid JSON');
      final stackTrace = StackTrace.current;

      // Act & Assert - Debe capturar todo sin problemas
      expect(
        () => errorLogger.logError(
          message: 'JSON parsing failed',
          exception: exception,
          stackTrace: stackTrace,
        ),
        returnsNormally,
      );
    });

    test('debe loguear con contexto enriquecido', () async {
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

    test('debe manejar exceptions nulas gracefully', () async {
      // Act & Assert - No debe fallar si exception es null
      expect(
        () => errorLogger.logError(message: 'Error without exception'),
        returnsNormally,
      );
    });

    test('debe soportar logging desde diferentes features', () async {
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
    test('debe manejar mensajes muy largos', () async {
      // Arrange
      final longMessage = 'x' * 10000;

      // Act & Assert
      expect(
        () => errorLogger.logError(message: longMessage),
        returnsNormally,
      );
    });

    test('debe manejar contextos con valores null', () async {
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

    test('debe manejar múltiples logs consecutivos', () async {
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
