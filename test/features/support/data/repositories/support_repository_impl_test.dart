import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/features/support/data/datasources/support_local_datasource.dart';
import 'package:ecommerce/features/support/data/models/contact_message_model.dart';
import 'package:ecommerce/features/support/data/repositories/support_repository_impl.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';

class MockSupportLocalDataSource extends Mock implements SupportLocalDataSource {}

class FakeContactMessageModel extends Fake implements ContactMessageModel {}

void main() {
  late SupportRepositoryImpl supportRepository;
  late MockSupportLocalDataSource mockLocalDataSource;

  setUpAll(() {
    registerFallbackValue(FAQCategory.general);
    registerFallbackValue(FakeContactMessageModel());
  });

  setUp(() {
    mockLocalDataSource = MockSupportLocalDataSource();
    supportRepository = SupportRepositoryImpl(localDataSource: mockLocalDataSource);
  });

  group('SupportRepositoryImpl - Error Handling', () {
    test('should return Left when getFAQs throws ParseException', () async {
      // Arrange
      const parseException = ParseException(message: 'JSON corrupted');
      when(() => mockLocalDataSource.getFAQs())
          .thenThrow(parseException);

      // Act
      final result = await supportRepository.getFAQs();

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('should return Left when getFAQsByCategory throws ParseException', () async {
      // Arrange
      const parseException = ParseException(message: 'Data corrupted');
      when(() => mockLocalDataSource.getFAQsByCategory(any()))
          .thenThrow(parseException);

      // Act
      final result = await supportRepository.getFAQsByCategory(FAQCategory.orders);

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('should return Left when sendContactMessage throws UnknownException', () async {
      // Arrange
      const unknownException = UnknownException(message: 'Unexpected error');
      when(() => mockLocalDataSource.saveContactMessage(any()))
          .thenThrow(unknownException);

      // Act
      final result = await supportRepository.sendContactMessage(
        name: 'John Doe',
        email: 'john@example.com',
        subject: 'Help',
        message: 'I need help',
      );

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('should return Right when getFAQs succeeds', () async {
      // Arrange
      when(() => mockLocalDataSource.getFAQs())
          .thenAnswer((_) async => []);

      // Act
      final result = await supportRepository.getFAQs();

      // Assert
      expect(result.isRight(), isTrue);
    });

    test('should return Right when sendContactMessage succeeds', () async {
      // Arrange
      final message = ContactMessageModel(
        id: '1',
        name: 'John',
        email: 'john@example.com',
        subject: 'Help',
        message: 'Help me',
        timestamp: DateTime.now(),
      );
      when(() => mockLocalDataSource.saveContactMessage(any()))
          .thenAnswer((_) async => message);

      // Act
      final result = await supportRepository.sendContactMessage(
        name: 'John',
        email: 'john@example.com',
        subject: 'Help',
        message: 'Help me',
      );

      // Assert
      expect(result.isRight(), isTrue);
    });

    test('should return Right when getFAQsByCategory succeeds', () async {
      // Arrange
      when(() => mockLocalDataSource.getFAQsByCategory(any()))
          .thenAnswer((_) async => []);

      // Act
      final result = await supportRepository.getFAQsByCategory(FAQCategory.orders);

      // Assert
      expect(result.isRight(), isTrue);
    });
  });
}
