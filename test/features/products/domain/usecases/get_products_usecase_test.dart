import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import 'package:ecommerce/features/products/domain/usecases/get_products_usecase.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late GetProductsUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductsUseCase(repository: mockRepository);
  });

  group('GetProductsUseCase', () {
    test(
      'should return list of products when repository call is successful',
      () async {
        // Arrange
        final products = ProductFixtures.sampleProducts;
        when(
          () => mockRepository.getAllProducts(),
        ).thenAnswer((_) async => Right(products));

        // Act
        final result = await useCase();

        // Assert
        expect(result, isRight);
        result.fold((failure) => fail('Should not return failure'), (data) {
          expect(data, equals(products));
          expect(data.length, 3);
        });
        verify(() => mockRepository.getAllProducts()).called(1);
      },
    );

    test('should return ConnectionFailure when there is no internet', () async {
      // Arrange
      when(
        () => mockRepository.getAllProducts(),
      ).thenAnswer((_) async => const Left(ConnectionFailure()));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isLeft);
      expect(result, isLeftWithType<ConnectionFailure>());
      result.fold(
        (failure) => expect(failure, isA<ConnectionFailure>()),
        (data) => fail('Should not return data'),
      );
    });

    test('should return ServerFailure when server error occurs', () async {
      // Arrange
      when(
        () => mockRepository.getAllProducts(),
      ).thenAnswer((_) async => const Left(ServerFailure()));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isLeft);
      expect(result, isLeftWithType<ServerFailure>());
      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (data) => fail('Should not return data'),
      );
    });
  });
}
