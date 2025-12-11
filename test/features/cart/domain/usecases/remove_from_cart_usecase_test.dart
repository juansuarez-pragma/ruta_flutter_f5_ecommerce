import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/cart/domain/usecases/remove_from_cart_usecase.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late RemoveFromCartUseCase useCase;
  late MockCartRepository mockRepository;

  setUp(() {
    mockRepository = MockCartRepository();
    useCase = RemoveFromCartUseCase(repository: mockRepository);
  });

  group('RemoveFromCartUseCase', () {
    test('should call repository removeItem with productId', () async {
      // Arrange
      const productId = 1;
      when(() => mockRepository.removeItem(any())).thenAnswer((_) async {});

      // Act
      await useCase(productId);

      // Assert
      verify(() => mockRepository.removeItem(productId)).called(1);
    });

    test('should remove item with different productId', () async {
      // Arrange
      const productId = 42;
      when(() => mockRepository.removeItem(any())).thenAnswer((_) async {});

      // Act
      await useCase(productId);

      // Assert
      verify(() => mockRepository.removeItem(productId)).called(1);
    });

    test('should propagate exception from repository', () async {
      // Arrange
      when(() => mockRepository.removeItem(any()))
          .thenThrow(Exception('Item not found'));

      // Act & Assert
      expect(() => useCase(1), throwsException);
    });
  });
}
