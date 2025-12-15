import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import 'package:ecommerce/features/home/domain/usecases/get_home_data_usecase.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late GetHomeDataUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetHomeDataUseCase(repository: mockRepository);
  });

  group('GetHomeDataUseCase', () {
    test(
      'should return HomeData with categories and featured products',
      () async {
        // Arrange
        final categories = ProductFixtures.sampleCategories;
        final products = ProductFixtures.sampleProducts;
        when(
          () => mockRepository.getAllCategories(),
        ).thenAnswer((_) async => Right(categories));
        when(
          () => mockRepository.getAllProducts(),
        ).thenAnswer((_) async => Right(products));

        // Act
        final result = await useCase();

        // Assert
        expect(result, isRight);
        result.fold((failure) => fail('Should not return failure'), (homeData) {
          expect(homeData.categories, equals(categories));
          expect(homeData.featuredProducts.length, lessThanOrEqualTo(8));
        });
        verify(() => mockRepository.getAllCategories()).called(1);
        verify(() => mockRepository.getAllProducts()).called(1);
      },
    );

    test('should return failure when categories fetch fails', () async {
      // Arrange
      when(
        () => mockRepository.getAllCategories(),
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
      verifyNever(() => mockRepository.getAllProducts());
    });

    test('should return failure when products fetch fails', () async {
      // Arrange
      final categories = ProductFixtures.sampleCategories;
      when(
        () => mockRepository.getAllCategories(),
      ).thenAnswer((_) async => Right(categories));
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
