import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/cart/domain/usecases/get_cart_usecase.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late GetCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = GetCartUseCase(repository: mockRepository);
  });

  group('GetCartUseCase', () {
    test('should return cart items from repository', () async {
      // Arrange
      final cartItems = CartItemFixtures.sampleCartItems;
      when(
        () => mockRepository.getCartItems(),
      ).thenAnswer((_) async => cartItems);

      // Act
      final result = await useCase();

      // Assert
      expect(result, equals(cartItems));
      expect(result.length, 2);
      verify(() => mockRepository.getCartItems()).called(1);
    });

    test('should return empty list when cart is empty', () async {
      // Arrange
      when(() => mockRepository.getCartItems()).thenAnswer((_) async => []);

      // Act
      final result = await useCase();

      // Assert
      expect(result, isEmpty);
      verify(() => mockRepository.getCartItems()).called(1);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      when(
        () => mockRepository.getCartItems(),
      ).thenThrow(Exception('Storage error'));

      // Act & Assert
      expect(() => useCase(), throwsException);
    });
  });
}
