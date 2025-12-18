import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/core/error_handling/app_logger.dart';
import 'package:ecommerce/features/orders/data/datasources/order_local_datasource_impl.dart';
import 'package:ecommerce/features/orders/data/models/order_model.dart';
import 'package:ecommerce/features/orders/domain/entities/order.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}
class MockAppLogger extends Mock implements AppLogger {}

void main() {
  late OrderLocalDataSourceImpl orderDataSource;
  late MockSharedPreferences mockSharedPreferences;
  late MockAppLogger mockLogger;

  final testOrder = OrderModel(
    id: '1',
    items: const [],
    total: 100.0,
    createdAt: DateTime(2025),
  );

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    mockLogger = MockAppLogger();
    orderDataSource = OrderLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
      logger: mockLogger,
    );

    // Configure default mocks
    when(() => mockSharedPreferences.getString(any()))
        .thenReturn(null);
    when(() => mockSharedPreferences.setString(any(), any()))
        .thenAnswer((_) async => true);
  });

  group('OrderLocalDataSource - getOrders', () {
    test('should return an empty list when there are no saved orders', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(null);

      // Act
      final result = await orderDataSource.getOrders();

      // Assert
      expect(result, isEmpty);
    });

    test('should return the saved orders when they exist', () async {
      // Arrange
      final orders = [testOrder];
      final jsonString = json.encode(orders.map((o) => o.toJson()).toList());
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(jsonString);

      // Act
      final result = await orderDataSource.getOrders();

      // Assert
      expect(result, isNotEmpty);
      expect(result.first.id, equals('1'));
    });

    test('should handle empty JSON', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn('');

      // Act
      final result = await orderDataSource.getOrders();

      // Assert
      expect(result, isEmpty);
    });

    test('should rethrow ParseException when JSON is invalid', () async {
      // Arrange
      const invalidJson = '[{incomplete}]';
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(invalidJson);

      // Act & Assert
      expect(
        () => orderDataSource.getOrders(),
        throwsA(isA<ParseException>()),
      );
    });
  });

  group('OrderLocalDataSource - getOrderById', () {
    test('should return the order when it exists', () async {
      // Arrange
      final orders = [testOrder];
      final jsonString = json.encode(orders.map((o) => o.toJson()).toList());
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(jsonString);

      // Act
      final result = await orderDataSource.getOrderById('1');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, equals('1'));
    });

    test('should return null when order does not exist', () async {
      // Arrange
      final orders = [testOrder];
      final jsonString = json.encode(orders.map((o) => o.toJson()).toList());
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(jsonString);

      // Act
      final result = await orderDataSource.getOrderById('999');

      // Assert
      expect(result, isNull);
    });

    test('should differentiate "not found" from a technical error', () async {
      // Arrange
      final orders = [testOrder];
      final jsonString = json.encode(orders.map((o) => o.toJson()).toList());
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(jsonString);

      // Act - Search for an order that does not exist
      final result = await orderDataSource.getOrderById('nonexistent');

      // Assert - Should return null, not throw an exception
      expect(result, isNull);
    });

    test('should throw if getOrders fails', () async {
      // Arrange - Invalid JSON will throw in getOrders
      const invalidJson = '{"invalid: json}';
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(invalidJson);

      // Act & Assert - Should throw UnknownException (wraps ParseException)
      expect(
        () => orderDataSource.getOrderById('1'),
        throwsA(isA<UnknownException>()),
      );
    });

    test('should handle multiple orders correctly', () async {
      // Arrange
      final order1 = testOrder;
      final order2 = OrderModel(
        id: '2',
        items: const [],
        total: 200.0,
        status: OrderStatus.pending,
        createdAt: DateTime(2025, 1, 2),
      );
      final orders = [order1, order2];
      final jsonString = json.encode(orders.map((o) => o.toJson()).toList());
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(jsonString);

      // Act
      final result = await orderDataSource.getOrderById('2');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, equals('2'));
      expect(result.total, equals(200.0));
    });
  });

  group('OrderLocalDataSource - saveOrder', () {
    test('should save an order correctly', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(null);

      // Act
      await orderDataSource.saveOrder(testOrder);

      // Assert
      verify(() => mockSharedPreferences.setString(any(), any()))
          .called(1);
    });

    test('should append a new order correctly', () async {
      // Arrange
      final order1 = testOrder;
      final order2 = OrderModel(
        id: '2',
        items: const [],
        total: 200.0,
        status: OrderStatus.pending,
        createdAt: DateTime(2025, 1, 2),
      );
      final orders = [order1];
      final jsonString = json.encode(orders.map((o) => o.toJson()).toList());
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(jsonString);

      // Act
      await orderDataSource.saveOrder(order2);

      // Assert - Should call setString to persist orders
      verify(() => mockSharedPreferences.setString(any(), any()))
          .called(1);
    });
  });

  group('OrderLocalDataSource - deleteOrder', () {
    test('should delete an order by id', () async {
      // Arrange
      final orders = [testOrder];
      final jsonString = json.encode(orders.map((o) => o.toJson()).toList());
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(jsonString);

      // Act
      await orderDataSource.deleteOrder('1');

      // Assert
      verify(() => mockSharedPreferences.setString(any(), any()))
          .called(1);
    });

    test('should handle deleting an order that does not exist', () async {
      // Arrange
      final orders = [testOrder];
      final jsonString = json.encode(orders.map((o) => o.toJson()).toList());
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(jsonString);

      // Act - Should not throw
      await orderDataSource.deleteOrder('999');

      // Assert - Should still try to persist
      verify(() => mockSharedPreferences.setString(any(), any()))
          .called(1);
    });
  });

  group('OrderLocalDataSource - Error Handling Integration', () {
    test('should rethrow ParseException when JSON is invalid in getOrders', () async {
      // Arrange
      const invalidJson = '[{incomplete}]';
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(invalidJson);

      // Act & Assert
      expect(
        () => orderDataSource.getOrders(),
        throwsA(isA<ParseException>()),
      );
    });

    test('should rethrow when JSON is invalid in getOrderById', () async {
      // Arrange
      const invalidJson = '{"invalid: json}';
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(invalidJson);

      // Act & Assert
      expect(
        () => orderDataSource.getOrderById('1'),
        throwsA(isA<UnknownException>()),
      );
    });
  });
}
