import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/features/support/support.dart';
import '../../../../helpers/mocks.dart';

void main() {
  late GetFAQsUseCase useCase;
  late MockSupportRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FAQCategory.general);
  });

  setUp(() {
    mockRepository = MockSupportRepository();
    useCase = GetFAQsUseCase(repository: mockRepository);
  });

  const tFAQs = FAQFixtures.sampleFAQs;

  group('GetFAQsUseCase', () {
    test('should return all FAQs when no category is specified', () async {
      // Arrange
      when(() => mockRepository.getFAQs())
          .thenAnswer((_) async => const Right(tFAQs));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right(tFAQs));
      verify(() => mockRepository.getFAQs()).called(1);
      verifyNever(() => mockRepository.getFAQsByCategory(any()));
    });

    test('should return FAQs filtered by category when category is specified', () async {
      // Arrange
      const ordersFAQs = [FAQFixtures.sampleFAQ];
      when(() => mockRepository.getFAQsByCategory(FAQCategory.orders))
          .thenAnswer((_) async => const Right(ordersFAQs));

      // Act
      final result = await useCase(category: FAQCategory.orders);

      // Assert
      expect(result, const Right(ordersFAQs));
      verify(() => mockRepository.getFAQsByCategory(FAQCategory.orders)).called(1);
      verifyNever(() => mockRepository.getFAQs());
    });

    test('should return failure when repository fails', () async {
      // Arrange
      final failure = SupportFailure.loadFaqsFailed();
      when(() => mockRepository.getFAQs())
          .thenAnswer((_) async => Left(failure));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (l) => expect(l.type, SupportFailureType.loadFaqsFailed),
        (r) => fail('Should return Left'),
      );
    });
  });
}
