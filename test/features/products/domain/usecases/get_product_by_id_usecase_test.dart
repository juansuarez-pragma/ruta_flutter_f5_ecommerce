import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import 'package:ecommerce/features/products/domain/usecases/get_product_by_id_usecase.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late GetProductByIdUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProductByIdUseCase(repository: mockRepository);
  });

  group('GetProductByIdUseCase', () {
    test('should return product when repository call is successful', () async {
      // Arrange
      final product = ProductFixtures.sampleProduct;
      when(() => mockRepository.getProductById(1))
          .thenAnswer((_) async => Right(product));

      // Act
      final result = await useCase(1);

      // Assert
      expect(result, isRight);
      result.fold(
        (failure) => fail('Should not return failure'),
        (data) {
          expect(data.id, 1);
          expect(data.title, 'Test Product');
          expect(data.price, 99.99);
        },
      );
      verify(() => mockRepository.getProductById(1)).called(1);
    });

    test('should return NotFoundFailure when product does not exist', () async {
      // Arrange
      when(() => mockRepository.getProductById(999))
          .thenAnswer((_) async => const Left(NotFoundFailure()));

      // Act
      final result = await useCase(999);

      // Assert
      expect(result, isLeft);
      expect(result, isLeftWithType<NotFoundFailure>());
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (data) => fail('Should not return data'),
      );
    });

    test('should return ConnectionFailure when there is no internet',
        () async {
      // Arrange
      when(() => mockRepository.getProductById(any()))
          .thenAnswer((_) async => const Left(ConnectionFailure()));

      // Act
      final result = await useCase(1);

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
