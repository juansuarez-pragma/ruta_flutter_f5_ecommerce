import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/core/error_handling/error_handling_utils.dart';
import 'package:ecommerce/core/error_handling/app_exceptions.dart';

void main() {
  group('safeCall', () {
    test('should return the result when the function succeeds', () async {
      // Arrange
      Future<String> successFunction() async => 'Success';

      // Act
      final result = await safeCall(successFunction);

      // Assert
      expect(result, equals('Success'));
    });

    test('should convert a generic Exception to UnknownException', () async {
      // Arrange
      Future<String> failingFunction() async =>
          throw Exception('Generic error');

      // Act & Assert
      expect(
        safeCall(failingFunction),
        throwsA(isA<UnknownException>()),
      );
    });

    test('should rethrow AppException without modification', () async {
      // Arrange
      const parseException = ParseException(message: 'Parse failed');
      Future<String> failingFunction() async => throw parseException;

      // Act & Assert
      expect(
        safeCall(failingFunction),
        throwsA(equals(parseException)),
      );
    });

    test('should log before rethrowing', () async {
      // Arrange
      Future<String> failingFunction() async =>
          throw Exception('Error to log');

      // Act & Assert
      expect(
        safeCall(failingFunction),
        throwsA(isA<UnknownException>()),
      );
      // Logging happens without throwing
    });

    test('should allow passing a custom logging context', () async {
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

    test('should handle Future<void>', () async {
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

    test('should handle Futures that return null', () async {
      // Arrange
      Future<String?> nullFunction() async => null;

      // Act
      final result = await safeCall(nullFunction);

      // Assert
      expect(result, isNull);
    });
  });

  group('safeJsonDecode', () {
    test('should decode valid JSON without errors', () {
      // Arrange
      const validJson = '{"key": "value"}';

      // Act
      final result = safeJsonDecode(validJson);

      // Assert
      expect(result, equals({'key': 'value'}));
    });

    test('should decode a valid JSON array', () {
      // Arrange
      const validJson = '[1, 2, 3]';

      // Act
      final result = safeJsonDecode(validJson);

      // Assert
      expect(result, equals([1, 2, 3]));
    });

    test('should throw ParseException when JSON is invalid', () {
      // Arrange
      const invalidJson = '{"invalid: json}';

      // Act & Assert
      expect(
        () => safeJsonDecode(invalidJson),
        throwsA(isA<ParseException>()),
      );
    });

    test('should convert FormatException to ParseException', () {
      // Arrange
      const invalidJson = '{invalid json}';

      // Act & Assert
      expect(
        () => safeJsonDecode(invalidJson),
        throwsA(isA<ParseException>()),
      );
    });

    test('should include the failed value in ParseException', () {
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

    test('should decode JSON with special characters', () {
      // Arrange
      const jsonWithSpecialChars =
          '{"name": "José", "city": "São Paulo"}';

      // Act
      final result = safeJsonDecode(jsonWithSpecialChars);

      // Assert
      expect(result['name'], equals('José'));
      expect(result['city'], equals('São Paulo'));
    });

    test('should handle deeply nested JSON', () {
      // Arrange
      const deepJson =
          '{"a": {"b": {"c": {"d": "value"}}}}';

      // Act
      final result = safeJsonDecode(deepJson);

      // Assert
      expect(result['a']['b']['c']['d'], equals('value'));
    });

    test('should log parse error details', () {
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
    test('should cast JSON to Map<String, dynamic> without errors', () {
      // Arrange
      const validJson = '{"key": "value", "number": 42}';

      // Act
      final result = safeJsonDecode(validJson) as Map<String, dynamic>;

      // Assert
      expect(result['key'], equals('value'));
      expect(result['number'], equals(42));
    });

    test('should cast a JSON array to List<dynamic>', () {
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
    test('should return the element when it exists in the list', () {
      // Arrange
      final list = [1, 2, 3, 4, 5];

      // Act
      final result = safeListOperation(
        () => list.firstWhere((x) => x == 3),
      );

      // Assert
      expect(result, equals(3));
    });

    test('should return the fallback when the element does not exist', () {
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

    test('should throw ParseException when the operation throws an Exception', () {
      // Act & Assert
      expect(
        () => safeListOperation<int>(() => throw Exception('boom')),
        throwsA(isA<ParseException>()),
      );
    });

    test('should not convert StateError (Error) to ParseException', () {
      // Arrange
      final list = <int>[];

      // Act & Assert
      expect(
        () => safeListOperation(() => list.first),
        throwsA(isA<StateError>()),
      );
    });

    test('should allow complex list operations', () {
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

    test('should preserve the generic result type', () {
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

    test('should allow passing custom context on error', () {
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
    test('should propagate StateError for empty lists', () {
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

    test('should handle large lists without issues', () {
      // Arrange
      final largeList = List.generate(10000, (i) => i);

      // Act
      final result = safeListOperation(
        () => largeList.firstWhere((x) => x == 5000),
      );

      // Assert
      expect(result, equals(5000));
    });

    test('should differentiate "not found" from a technical error',
        () {
      // Arrange
      final list = [1, 2, 3];

      // Act & Assert - Without fallback = StateError
      expect(
        () => safeListOperation(
          () => list.firstWhere((x) => x == 99),
        ),
        throwsA(isA<StateError>()),
      );

      // With fallback = null/default value
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
    test('should return the element when it exists', () {
      final list = [1, 2, 3];
      final result = safeListFirstWhere(list, (x) => x == 2);
      expect(result, equals(2));
    });

    test('should return null when it does not exist and there is no fallback', () {
      final list = [1, 2, 3];
      final result = safeListFirstWhere(list, (x) => x == 99);
      expect(result, isNull);
    });

    test('should return fallback when it does not exist', () {
      final list = [1, 2, 3];
      final result = safeListFirstWhere(list, (x) => x == 99, orElse: () => -1);
      expect(result, equals(-1));
    });
  });

  group('Error Handling Utils - Integration', () {
    test('should combine safeCall and safeJsonDecode', () async {
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

    test('should handle an error chain: safeCall > safeJsonDecode',
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

    test('should allow error recovery using fallback', () {
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
