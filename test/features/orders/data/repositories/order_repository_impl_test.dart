import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/features/orders/data/datasources/order_local_datasource.dart';
import 'package:ecommerce/features/orders/data/models/order_model.dart';
import 'package:ecommerce/features/orders/data/repositories/order_repository_impl.dart';
import 'package:ecommerce/features/orders/domain/entities/order.dart';

class MockOrderLocalDataSource extends Mock implements OrderLocalDataSource {}

class FakeOrderModel extends Fake implements OrderModel {}

void main() {
  late OrderRepositoryImpl orderRepository;
  late MockOrderLocalDataSource mockLocalDataSource;

  final testOrder = OrderModel(
    id: '1',
    items: const [],
    total: 100.0,
    createdAt: DateTime(2025),
  );

  setUpAll(() {
    registerFallbackValue(FakeOrderModel());
  });

  setUp(() {
    mockLocalDataSource = MockOrderLocalDataSource();
    orderRepository = OrderRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('OrderRepositoryImpl - Error Handling', () {
    test('debe retornar error si ParseException al obtener órdenes', () async {
      // Arrange
      const parseException = ParseException(message: 'JSON corrupted');
      when(() => mockLocalDataSource.getOrders())
          .thenThrow(parseException);

      // Act & Assert
      expect(
        () => orderRepository.getOrders(),
        throwsA(isA<ParseException>()),
      );
    });

    test('debe retornar error si UnknownException al guardar orden', () async {
      // Arrange
      const unknownException = UnknownException(message: 'Storage error');
      when(() => mockLocalDataSource.saveOrder(any()))
          .thenThrow(unknownException);

      // Act & Assert
      expect(
        () => orderRepository.saveOrder(testOrder),
        throwsA(isA<UnknownException>()),
      );
    });

    test('debe retornar error si ParseException al obtener orden por ID', () async {
      // Arrange
      const parseException = ParseException(message: 'Data error');
      when(() => mockLocalDataSource.getOrderById(any()))
          .thenThrow(parseException);

      // Act & Assert
      expect(
        () => orderRepository.getOrderById('1'),
        throwsA(isA<ParseException>()),
      );
    });

    test('debe retornar error si UnknownException al eliminar orden', () async {
      // Arrange
      const unknownException = UnknownException(message: 'Delete error');
      when(() => mockLocalDataSource.deleteOrder(any()))
          .thenThrow(unknownException);

      // Act & Assert
      expect(
        () => orderRepository.deleteOrder('1'),
        throwsA(isA<UnknownException>()),
      );
    });

    test('debe retornar lista si getOrders exitoso', () async {
      // Arrange
      when(() => mockLocalDataSource.getOrders())
          .thenAnswer((_) async => [testOrder]);

      // Act
      final result = await orderRepository.getOrders();

      // Assert
      expect(result, isNotEmpty);
      expect(result.first.id, equals('1'));
    });

    test('debe guardar orden si saveOrder exitoso', () async {
      // Arrange
      when(() => mockLocalDataSource.saveOrder(any()))
          .thenAnswer((_) async => {});

      // Act & Assert
      expect(
        () => orderRepository.saveOrder(testOrder),
        returnsNormally,
      );
    });

    test('debe obtener orden si getOrderById exitoso', () async {
      // Arrange
      when(() => mockLocalDataSource.getOrderById(any()))
          .thenAnswer((_) async => testOrder);

      // Act
      final result = await orderRepository.getOrderById('1');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, equals('1'));
    });

    test('debe eliminar orden si deleteOrder exitoso', () async {
      // Arrange
      when(() => mockLocalDataSource.deleteOrder(any()))
          .thenAnswer((_) async => {});

      // Act & Assert
      expect(
        () => orderRepository.deleteOrder('1'),
        returnsNormally,
      );
    });

    test('debe retornar null si orden no existe', () async {
      // Arrange
      when(() => mockLocalDataSource.getOrderById(any()))
          .thenAnswer((_) async => null);

      // Act
      final result = await orderRepository.getOrderById('999');

      // Assert
      expect(result, isNull);
    });
  });

  group('OrderRepositoryImpl - Multiple Orders', () {
    test('debe manejar múltiples órdenes sin errores', () async {
      // Arrange
      final orders = [
        testOrder,
        OrderModel(
          id: '2',
          items: const [],
          total: 200.0,
          status: OrderStatus.pending,
          createdAt: DateTime(2025, 1, 2),
        ),
      ];
      when(() => mockLocalDataSource.getOrders())
          .thenAnswer((_) async => orders);

      // Act
      final result = await orderRepository.getOrders();

      // Assert
      expect(result.length, equals(2));
    });
  });
}
