import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fake_store_api_client/fake_store_api_client.dart';

import 'package:ecommerce/features/categories/domain/usecases/get_categories_usecase.dart';
import '../../../../helpers/mocks.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late GetCategoriesUseCase useCase;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetCategoriesUseCase(repository: mockRepository);
  });

  group('GetCategoriesUseCase', () {
    test(
      'should return list of categories when repository call is successful',
      () async {
        // Arrange
        final categories = ProductFixtures.sampleCategories;
        when(
          () => mockRepository.getAllCategories(),
        ).thenAnswer((_) async => Right(categories));

        // Act
        final result = await useCase();

        // Assert
        expect(result, isRight);
        result.fold((failure) => fail('Should not return failure'), (data) {
          expect(data, equals(categories));
          expect(data.length, 4);
          expect(data.contains('electronics'), true);
          expect(data.contains('jewelery'), true);
        });
        verify(() => mockRepository.getAllCategories()).called(1);
      },
    );

    test('should return ConnectionFailure when there is no internet', () async {
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
    });

    test('should return ServerFailure when server error occurs', () async {
      // Arrange
      when(
        () => mockRepository.getAllCategories(),
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
