import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import 'package:ecommerce/features/products/domain/usecases/get_products_by_category_usecase.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late GetProductsByCategoryUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsByCategoryUseCase(repository: mockRepository);
  });

  group('GetProductsByCategoryUseCase', () {
    test('should return products for given category', () async {
      // Arrange
      final electronicsProducts = ProductFixtures.sampleProducts
          .where((p) => p.category == 'electronics')
          .toList();
      when(
        () => mockRepository.getProductsByCategory('electronics'),
      ).thenAnswer((_) async => Right(electronicsProducts));

      // Act
      final result = await useCase('electronics');

      // Assert
      expect(result, isRight);
      result.fold((failure) => fail('Should not return failure'), (data) {
        expect(data.every((p) => p.category == 'electronics'), true);
      });
      verify(
        () => mockRepository.getProductsByCategory('electronics'),
      ).called(1);
    });

    test('should return empty list for unknown category', () async {
      // Arrange
      when(
        () => mockRepository.getProductsByCategory('unknown'),
      ).thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase('unknown');

      // Assert
      expect(result, isRight);
      result.fold(
        (failure) => fail('Should not return failure'),
        (data) => expect(data, isEmpty),
      );
    });

    test('should return ConnectionFailure when there is no internet', () async {
      // Arrange
      when(
        () => mockRepository.getProductsByCategory(any()),
      ).thenAnswer((_) async => const Left(ConnectionFailure()));

      // Act
      final result = await useCase('electronics');

      // Assert
      expect(result, isLeft);
      expect(result, isLeftWithType<ConnectionFailure>());
      result.fold(
        (failure) => expect(failure, isA<ConnectionFailure>()),
        (data) => fail('Should not return data'),
      );
    });
  });
}
