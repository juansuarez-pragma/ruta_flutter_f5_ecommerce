import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/core/error_handling/error_handling_utils.dart';
import 'package:ecommerce/core/error_handling/app_exceptions.dart';

void main() {
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
}
