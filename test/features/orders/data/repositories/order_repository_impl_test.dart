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
    test('should throw ParseException when getOrders fails to parse', () async {
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

    test('should throw UnknownException when saveOrder fails', () async {
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

    test('should throw ParseException when getOrderById fails to parse', () async {
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

    test('should throw UnknownException when deleteOrder fails', () async {
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

    test('should return orders when getOrders succeeds', () async {
      // Arrange
      when(() => mockLocalDataSource.getOrders())
          .thenAnswer((_) async => [testOrder]);

      // Act
      final result = await orderRepository.getOrders();

      // Assert
      expect(result, isNotEmpty);
      expect(result.first.id, equals('1'));
    });

    test('should save order when saveOrder succeeds', () async {
      // Arrange
      when(() => mockLocalDataSource.saveOrder(any()))
          .thenAnswer((_) async => {});

      // Act & Assert
      expect(
        () => orderRepository.saveOrder(testOrder),
        returnsNormally,
      );
    });

    test('should return order when getOrderById succeeds', () async {
      // Arrange
      when(() => mockLocalDataSource.getOrderById(any()))
          .thenAnswer((_) async => testOrder);

      // Act
      final result = await orderRepository.getOrderById('1');

      // Assert
      expect(result, isNotNull);
      expect(result!.id, equals('1'));
    });

    test('should delete order when deleteOrder succeeds', () async {
      // Arrange
      when(() => mockLocalDataSource.deleteOrder(any()))
          .thenAnswer((_) async => {});

      // Act & Assert
      expect(
        () => orderRepository.deleteOrder('1'),
        returnsNormally,
      );
    });

    test('should return null when order does not exist', () async {
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
    test('should handle multiple orders without errors', () async {
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
