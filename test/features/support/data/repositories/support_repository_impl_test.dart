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
    test('debe retornar Left si ParseException al obtener FAQs', () async {
      // Arrange
      const parseException = ParseException(message: 'JSON corrupted');
      when(() => mockLocalDataSource.getFAQs())
          .thenThrow(parseException);

      // Act
      final result = await supportRepository.getFAQs();

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('debe retornar Left si ParseException al obtener FAQs por categoría', () async {
      // Arrange
      const parseException = ParseException(message: 'Data corrupted');
      when(() => mockLocalDataSource.getFAQsByCategory(any()))
          .thenThrow(parseException);

      // Act
      final result = await supportRepository.getFAQsByCategory(FAQCategory.orders);

      // Assert
      expect(result.isLeft(), isTrue);
    });

    test('debe retornar Left si UnknownException al enviar mensaje', () async {
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

    test('debe retornar Right si getFAQs exitoso', () async {
      // Arrange
      when(() => mockLocalDataSource.getFAQs())
          .thenAnswer((_) async => []);

      // Act
      final result = await supportRepository.getFAQs();

      // Assert
      expect(result.isRight(), isTrue);
    });

    test('debe retornar Right si sendContactMessage exitoso', () async {
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

    test('debe retornar Right si getFAQsByCategory exitoso', () async {
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
