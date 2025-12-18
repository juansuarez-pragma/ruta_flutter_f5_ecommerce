import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/core/error_handling/error_handling_utils.dart';
import 'package:ecommerce/core/error_handling/app_exceptions.dart';

void main() {
  group('safeCall', () {
    test('debe retornar resultado si la función se ejecuta sin errores', () async {
      // Arrange
      Future<String> successFunction() async => 'Success';

      // Act
      final result = await safeCall(successFunction);

      // Assert
      expect(result, equals('Success'));
    });

    test('debe convertir Exception genérica a UnknownException', () async {
      // Arrange
      Future<String> failingFunction() async =>
          throw Exception('Generic error');

      // Act & Assert
      expect(
        safeCall(failingFunction),
        throwsA(isA<UnknownException>()),
      );
    });

    test('debe re-lanzar AppException sin modificar', () async {
      // Arrange
      const parseException = ParseException(message: 'Parse failed');
      Future<String> failingFunction() async => throw parseException;

      // Act & Assert
      expect(
        safeCall(failingFunction),
        throwsA(equals(parseException)),
      );
    });

    test('debe loguear antes de relanzar excepción', () async {
      // Arrange
      Future<String> failingFunction() async =>
          throw Exception('Error to log');

      // Act & Assert
      expect(
        safeCall(failingFunction),
        throwsA(isA<UnknownException>()),
      );
      // El logging ocurre sin excepciones
    });

    test('debe permitir logging context personalizado', () async {
      // Arrange
      Future<String> failingFunction() async => throw Exception('Error');
      const context = {'operation': 'test_operation'};

      // Act & Assert
      expect(
        safeCall(
          failingFunction,
          context: context,
        ),
        throwsA(isA<UnknownException>()),
      );
    });

    test('debe manejar Future<void>', () async {
      // Arrange
      Future<void> voidFunction() async => await Future.delayed(
        const Duration(milliseconds: 10),
      );

      // Act & Assert
      expect(
        () => safeCall(voidFunction),
        returnsNormally,
      );
    });

    test('debe manejar Futures que retornan null', () async {
      // Arrange
      Future<String?> nullFunction() async => null;

      // Act
      final result = await safeCall(nullFunction);

      // Assert
      expect(result, isNull);
    });
  });

  group('safeJsonDecode', () {
    test('debe decodificar JSON válido sin errores', () {
      // Arrange
      const validJson = '{"key": "value"}';

      // Act
      final result = safeJsonDecode(validJson);

      // Assert
      expect(result, equals({'key': 'value'}));
    });

    test('debe decodificar JSON array válido', () {
      // Arrange
      const validJson = '[1, 2, 3]';

      // Act
      final result = safeJsonDecode(validJson);

      // Assert
      expect(result, equals([1, 2, 3]));
    });

    test('debe lanzar ParseException si JSON es inválido', () {
      // Arrange
      const invalidJson = '{"invalid: json}';

      // Act & Assert
      expect(
        () => safeJsonDecode(invalidJson),
        throwsA(isA<ParseException>()),
      );
    });

    test('debe capturar FormatException y convertir a ParseException', () {
      // Arrange
      const invalidJson = '{invalid json}';

      // Act & Assert
      expect(
        () => safeJsonDecode(invalidJson),
        throwsA(isA<ParseException>()),
      );
    });

    test('debe incluir valor fallido en ParseException', () {
      // Arrange
      const invalidJson = '{"bad": json}';

      // Act & Assert
      expect(
        () => safeJsonDecode(invalidJson),
        throwsA(
          isA<ParseException>().having(
            (e) => e.failedValue,
            'failedValue',
            contains('bad'),
          ),
        ),
      );
    });

    test('debe decodificar JSON con caracteres especiales', () {
      // Arrange
      const jsonWithSpecialChars =
          '{"name": "José", "city": "São Paulo"}';

      // Act
      final result = safeJsonDecode(jsonWithSpecialChars);

      // Assert
      expect(result['name'], equals('José'));
      expect(result['city'], equals('São Paulo'));
    });

    test('debe manejar JSON nido profundo', () {
      // Arrange
      const deepJson =
          '{"a": {"b": {"c": {"d": "value"}}}}';

      // Act
      final result = safeJsonDecode(deepJson);

      // Assert
      expect(result['a']['b']['c']['d'], equals('value'));
    });

    test('debe loguear detalles del error de parseo', () {
      // Arrange
      const invalidJson = '{"incomplete": ';

      // Act & Assert
      expect(
        () => safeJsonDecode(invalidJson),
        throwsA(isA<ParseException>()),
      );
    });
  });

  group('safeJsonDecode - Type Casting', () {
    test('debe castear JSON a Map<String, dynamic> sin errores', () {
      // Arrange
      const validJson = '{"key": "value", "number": 42}';

      // Act
      final result = safeJsonDecode(validJson) as Map<String, dynamic>;

      // Assert
      expect(result['key'], equals('value'));
      expect(result['number'], equals(42));
    });

    test('debe castear JSON array a List<dynamic>', () {
      // Arrange
      const validJson = '[{"id": 1}, {"id": 2}]';

      // Act
      final result = safeJsonDecode(validJson) as List<dynamic>;

      // Assert
      expect(result.length, equals(2));
      expect(result[0]['id'], equals(1));
    });
  });

  group('safeListOperation', () {
    test('debe retornar elemento si existe en lista', () {
      // Arrange
      final list = [1, 2, 3, 4, 5];

      // Act
      final result = safeListOperation(
        () => list.firstWhere((x) => x == 3),
      );

      // Assert
      expect(result, equals(3));
    });

    test('debe retornar fallback si elemento no existe', () {
      // Arrange
      final list = [1, 2, 3, 4, 5];

      // Act
      final result = safeListOperation(
        () => list.firstWhere(
          (x) => x == 99,
          orElse: () => -1,
        ),
      );

      // Assert
      expect(result, equals(-1));
    });

    test('debe lanzar ParseException si la operación lanza Exception', () {
      // Act & Assert
      expect(
        () => safeListOperation<int>(() => throw Exception('boom')),
        throwsA(isA<ParseException>()),
      );
    });

    test('no debe convertir StateError (Error) a ParseException', () {
      // Arrange
      final list = <int>[];

      // Act & Assert
      expect(
        () => safeListOperation(() => list.first),
        throwsA(isA<StateError>()),
      );
    });

    test('debe permitir operaciones complejas en listas', () {
      // Arrange
      final list = [
        {'id': 1, 'name': 'A'},
        {'id': 2, 'name': 'B'},
        {'id': 3, 'name': 'C'},
      ];

      // Act
      final result = safeListOperation(
        () => list.firstWhere((x) => x['id'] == 2),
      );

      // Assert
      expect(result['name'], equals('B'));
    });

    test('debe mantener tipo genérico de resultado', () {
      // Arrange
      final stringList = ['a', 'b', 'c'];

      // Act
      final result = safeListOperation(
        () => stringList.firstWhere((x) => x == 'b'),
      );

      // Assert
      expect(result, isA<String>());
      expect(result, equals('b'));
    });

    test('debe permitir contexto personalizado en error', () {
      // Arrange
      const context = {'operation': 'findUser'};

      // Act & Assert
      expect(
        () => safeListOperation(
          () => throw Exception('boom'),
          context: context,
        ),
        throwsA(isA<ParseException>()),
      );
    });
  });

  group('safeListOperation - Edge Cases', () {
    test('debe propagar StateError en listas vacías', () {
      // Arrange
      final emptyList = <int>[];

      // Act & Assert
      expect(
        () => safeListOperation(
          () => emptyList.firstWhere((x) => true),
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('debe manejar listas grandes sin problemas', () {
      // Arrange
      final largeList = List.generate(10000, (i) => i);

      // Act
      final result = safeListOperation(
        () => largeList.firstWhere((x) => x == 5000),
      );

      // Assert
      expect(result, equals(5000));
    });

    test('debe diferenciar "elemento no encontrado" de "error técnico"',
        () {
      // Arrange
      final list = [1, 2, 3];

      // Act & Assert - Sin fallback = StateError
      expect(
        () => safeListOperation(
          () => list.firstWhere((x) => x == 99),
        ),
        throwsA(isA<StateError>()),
      );

      // Con fallback = null/valor por defecto
      expect(
        () => safeListOperation(
          () => list.firstWhere(
            (x) => x == 99,
            orElse: () => -1,
          ),
        ),
        returnsNormally,
      );
    });
  });

  group('safeListFirstWhere', () {
    test('debe retornar elemento si existe', () {
      final list = [1, 2, 3];
      final result = safeListFirstWhere(list, (x) => x == 2);
      expect(result, equals(2));
    });

    test('debe retornar null si no existe y no hay fallback', () {
      final list = [1, 2, 3];
      final result = safeListFirstWhere(list, (x) => x == 99);
      expect(result, isNull);
    });

    test('debe retornar fallback si no existe', () {
      final list = [1, 2, 3];
      final result = safeListFirstWhere(list, (x) => x == 99, orElse: () => -1);
      expect(result, equals(-1));
    });
  });

  group('Error Handling Utils - Integration', () {
    test('debe combinar safeCall y safeJsonDecode', () async {
      // Arrange
      Future<Map<String, dynamic>> parseRemoteData() async {
        const jsonData = '{"id": 1, "name": "Test"}';
        return safeJsonDecode(jsonData) as Map<String, dynamic>;
      }

      // Act
      final result = await safeCall(parseRemoteData);

      // Assert
      expect(result['id'], equals(1));
    });

    test('debe manejar cadena de errores: safeCall > safeJsonDecode',
        () async {
      // Arrange
      Future<void> failingChain() async {
        const invalidJson = '{"bad}';
        safeJsonDecode(invalidJson);
      }

      // Act & Assert
      expect(
        () => safeCall(failingChain),
        throwsA(isA<ParseException>()),
      );
    });

    test('debe permitir recuperación de errores con fallback', () {
      // Arrange
      final list = [
        {'id': 1},
        {'id': 2},
      ];

      // Act
      final result = safeListOperation(
        () => list.firstWhere(
          (x) => x['id'] == 999,
          orElse: () => {'id': -1},
        ),
      );

      // Assert
      expect(result['id'], equals(-1));
    });
  });
}
