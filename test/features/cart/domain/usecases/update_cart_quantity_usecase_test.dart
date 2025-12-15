import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/cart/domain/usecases/update_cart_quantity_usecase.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late UpdateCartQuantityUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = UpdateCartQuantityUseCase(repository: mockRepository);
  });

  group('UpdateCartQuantityUseCase', () {
    test(
      'should call repository updateQuantity with productId and quantity',
      () async {
        // Arrange
        const productId = 1;
        const quantity = 5;
        when(
          () => mockRepository.updateQuantity(any(), any()),
        ).thenAnswer((_) async {});

        // Act
        await useCase(productId, quantity);

        // Assert
        verify(
          () => mockRepository.updateQuantity(productId, quantity),
        ).called(1);
      },
    );

    test('should update to quantity of 1', () async {
      // Arrange
      const productId = 1;
      const quantity = 1;
      when(
        () => mockRepository.updateQuantity(any(), any()),
      ).thenAnswer((_) async {});

      // Act
      await useCase(productId, quantity);

      // Assert
      verify(
        () => mockRepository.updateQuantity(productId, quantity),
      ).called(1);
    });

    test('should update to high quantity', () async {
      // Arrange
      const productId = 1;
      const quantity = 99;
      when(
        () => mockRepository.updateQuantity(any(), any()),
      ).thenAnswer((_) async {});

      // Act
      await useCase(productId, quantity);

      // Assert
      verify(
        () => mockRepository.updateQuantity(productId, quantity),
      ).called(1);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      when(
        () => mockRepository.updateQuantity(any(), any()),
      ).thenThrow(Exception('Invalid quantity'));

      // Act & Assert
      expect(() => useCase(1, 5), throwsException);
    });
  });
}
