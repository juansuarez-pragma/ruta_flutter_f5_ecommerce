import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import 'package:ecommerce/features/search/domain/usecases/search_products_usecase.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late SearchProductsUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = SearchProductsUseCase(repository: mockRepository);
  });

  group('SearchProductsUseCase', () {
    test('should return filtered products matching query', () async {
      // Arrange
      final products = ProductFixtures.sampleProducts;
      when(
        () => mockRepository.getAllProducts(),
      ).thenAnswer((_) async => Right(products));

      // Act - search for "Test"
      final result = await useCase('Test');

      // Assert
      expect(result, isRight);
      result.fold((failure) => fail('Should not return failure'), (data) {
        expect(data.length, 1);
        expect(data.first.title, contains('Test'));
      });
    });

    test('should return empty list when no products match query', () async {
      // Arrange
      final products = ProductFixtures.sampleProducts;
      when(
        () => mockRepository.getAllProducts(),
      ).thenAnswer((_) async => Right(products));

      // Act - search for something that doesn't exist
      final result = await useCase('NonExistentProduct12345');

      // Assert
      expect(result, isRight);
      result.fold(
        (failure) => fail('Should not return failure'),
        (data) => expect(data, isEmpty),
      );
    });

    test('should be case insensitive', () async {
      // Arrange
      final products = ProductFixtures.sampleProducts;
      when(
        () => mockRepository.getAllProducts(),
      ).thenAnswer((_) async => Right(products));

      // Act - search with different cases
      final resultLower = await useCase('test');
      final resultUpper = await useCase('TEST');
      final resultMixed = await useCase('TeSt');

      // Assert - all should return same result
      expect(resultLower, isRight);
      expect(resultUpper, isRight);
      expect(resultMixed, isRight);

      resultLower.fold(
        (f) => fail('Should not fail'),
        (data) => expect(data.length, 1),
      );
      resultUpper.fold(
        (f) => fail('Should not fail'),
        (data) => expect(data.length, 1),
      );
      resultMixed.fold(
        (f) => fail('Should not fail'),
        (data) => expect(data.length, 1),
      );
    });

    test('should return ConnectionFailure when there is no internet', () async {
      // Arrange
      when(
        () => mockRepository.getAllProducts(),
      ).thenAnswer((_) async => const Left(ConnectionFailure()));

      // Act
      final result = await useCase('test');

      // Assert
      expect(result, isLeft);
      expect(result, isLeftWithType<ConnectionFailure>());
      result.fold(
        (failure) => expect(failure, isA<ConnectionFailure>()),
        (data) => fail('Should not return data'),
      );
    });

    test('should return all products when query matches multiple', () async {
      // Arrange
      final products = ProductFixtures.sampleProducts;
      when(
        () => mockRepository.getAllProducts(),
      ).thenAnswer((_) async => Right(products));

      // Act - search for "Product" which is in all titles
      final result = await useCase('Product');

      // Assert
      expect(result, isRight);
      result.fold(
        (failure) => fail('Should not return failure'),
        (data) => expect(data.length, 3),
      );
    });
  });
}
