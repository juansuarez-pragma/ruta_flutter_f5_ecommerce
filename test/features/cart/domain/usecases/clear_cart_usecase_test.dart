import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/cart/domain/usecases/clear_cart_usecase.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late ClearCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = ClearCartUseCase(repository: mockRepository);
  });

  group('ClearCartUseCase', () {
    test('should call repository clearCart', () async {
      // Arrange
      when(() => mockRepository.clearCart()).thenAnswer((_) async {});

      // Act
      await useCase();

      // Assert
      verify(() => mockRepository.clearCart()).called(1);
    });

    test('should complete without error when cart is already empty', () async {
      // Arrange
      when(() => mockRepository.clearCart()).thenAnswer((_) async {});

      // Act
      await useCase();

      // Assert
      verify(() => mockRepository.clearCart()).called(1);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      when(
        () => mockRepository.clearCart(),
      ).thenThrow(Exception('Storage error'));

      // Act & Assert
      expect(() => useCase(), throwsException);
    });
  });
}
