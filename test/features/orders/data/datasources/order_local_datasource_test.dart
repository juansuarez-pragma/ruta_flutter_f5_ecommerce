import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/features/orders/data/datasources/order_local_datasource_impl.dart';
import 'package:ecommerce/features/orders/data/models/order_model.dart';
import 'package:ecommerce/features/orders/domain/entities/order.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late OrderLocalDataSourceImpl orderDataSource;
  late MockSharedPreferences mockSharedPreferences;

  final testOrder = OrderModel(
    id: '1',
    items: const [],
    total: 100.0,
    createdAt: DateTime(2025),
  );

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    orderDataSource = OrderLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );

    // Configurar mocks por defecto
    when(() => mockSharedPreferences.getString(any()))
        .thenReturn(null);
    when(() => mockSharedPreferences.setString(any(), any()))
        .thenAnswer((_) async => true);
  });

  group('OrderLocalDataSource - getOrders', () {
    test('debe retornar lista vacía si no hay órdenes guardadas', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(null);

      // Act
      final result = await orderDataSource.getOrders();

      // Assert
      expect(result, isEmpty);
    });

    test('debe retornar lista de órdenes si existen', () async {
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

    test('debe manejar JSON vacío', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn('');

      // Act
      final result = await orderDataSource.getOrders();

      // Assert
      expect(result, isEmpty);
    });

    test('debe loguear y relanzar ParseException si JSON inválido', () async {
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
    test('debe retornar orden si existe', () async {
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

    test('debe retornar null si orden no existe', () async {
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

    test('debe diferenciar "no encontrado" de "error técnico"', () async {
      // Arrange
      final orders = [testOrder];
      final jsonString = json.encode(orders.map((o) => o.toJson()).toList());
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(jsonString);

      // Act - Buscar orden que no existe
      final result = await orderDataSource.getOrderById('nonexistent');

      // Assert - Debe retornar null, no lanzar excepción
      expect(result, isNull);
    });

    test('debe relanzar excepción si getOrders falla', () async {
      // Arrange - JSON inválido causará excepción en getOrders
      const invalidJson = '{"invalid: json}';
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(invalidJson);

      // Act & Assert - Debe relanzar UnknownException (wrapper de ParseException)
      expect(
        () => orderDataSource.getOrderById('1'),
        throwsA(isA<UnknownException>()),
      );
    });

    test('debe manejar múltiples órdenes correctamente', () async {
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
    test('debe guardar orden correctamente', () async {
      // Arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(null);

      // Act
      await orderDataSource.saveOrder(testOrder);

      // Assert
      verify(() => mockSharedPreferences.setString(any(), any()))
          .called(1);
    });

    test('debe agregar nueva orden correctamente', () async {
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

      // Assert - Debe llamar setString para guardar las órdenes
      verify(() => mockSharedPreferences.setString(any(), any()))
          .called(1);
    });
  });

  group('OrderLocalDataSource - deleteOrder', () {
    test('debe eliminar orden por ID', () async {
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

    test('debe manejar eliminación de orden que no existe', () async {
      // Arrange
      final orders = [testOrder];
      final jsonString = json.encode(orders.map((o) => o.toJson()).toList());
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(jsonString);

      // Act - No debe lanzar excepción
      await orderDataSource.deleteOrder('999');

      // Assert - Debe intentar guardar de todas formas
      verify(() => mockSharedPreferences.setString(any(), any()))
          .called(1);
    });
  });

  group('OrderLocalDataSource - Error Handling Integration', () {
    test('debe loguear y relanzar ParseException si JSON inválido en getOrders', () async {
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

    test('debe loguear y relanzar excepción en getOrderById si JSON inválido', () async {
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
