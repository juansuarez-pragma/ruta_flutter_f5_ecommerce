import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/cart/domain/usecases/add_to_cart_usecase.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late AddToCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(CartItemFixtures.sampleCartItem);
  });

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = AddToCartUseCase(repository: mockRepository);
  });

  group('AddToCartUseCase', () {
    test('should call repository addItem with cart item', () async {
      // Arrange
      final cartItem = CartItemFixtures.sampleCartItem;
      when(() => mockRepository.addItem(any())).thenAnswer((_) async {});

      // Act
      await useCase(cartItem);

      // Assert
      verify(() => mockRepository.addItem(cartItem)).called(1);
    });

    test('should add item with specified quantity', () async {
      // Arrange
      final cartItem = CartItemFixtures.cartItemWithQuantity3;
      when(() => mockRepository.addItem(any())).thenAnswer((_) async {});

      // Act
      await useCase(cartItem);

      // Assert
      verify(() => mockRepository.addItem(cartItem)).called(1);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      final cartItem = CartItemFixtures.sampleCartItem;
      when(
        () => mockRepository.addItem(any()),
      ).thenThrow(Exception('Storage error'));

      // Act & Assert
      expect(() => useCase(cartItem), throwsException);
    });
  });
}
