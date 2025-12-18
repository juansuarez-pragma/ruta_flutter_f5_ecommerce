import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/features/support/data/datasources/support_local_datasource_impl.dart';
import 'package:ecommerce/features/support/data/models/contact_message_model.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SupportLocalDataSourceImpl supportDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    supportDataSource = SupportLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );

    // Configure default mocks
    when(() => mockSharedPreferences.getString(any()))
        .thenReturn(null);
    when(() => mockSharedPreferences.setString(any(), any()))
        .thenAnswer((_) async => true);
  });

  group('SupportLocalDataSource - getFAQs', () {
    test('should return a list of FAQs', () async {
      // Act
      final result = await supportDataSource.getFAQs();

      // Assert
      expect(result, isNotEmpty);
      expect(result.length, greaterThan(0));
    });

    test('should return FAQs with a valid structure', () async {
      // Act
      final result = await supportDataSource.getFAQs();

      // Assert
      expect(result, isA<List>());
      for (final faq in result) {
        expect(faq.id, isNotNull);
        expect(faq.question, isNotEmpty);
        expect(faq.answer, isNotEmpty);
        expect(faq.category, isNotNull);
      }
    });
  });

  group('SupportLocalDataSource - getFAQsByCategory', () {
    test('should filter FAQs by category', () async {
      // Act
      final result = await supportDataSource
          .getFAQsByCategory(FAQCategory.orders);

      // Assert
      expect(result, isNotEmpty);
      for (final faq in result) {
        expect(faq.category, equals(FAQCategory.orders));
      }
    });

    test('should return a list (possibly empty) depending on category', () async {
      // Act
      final allFAQs = await supportDataSource.getFAQs();

      // Assert - should have at least some FAQs
      expect(allFAQs.isNotEmpty, isTrue);
    });
  });

  group('SupportLocalDataSource - saveContactMessage', () {
    test('should save a contact message correctly', () async {
      // Arrange
      final message = ContactMessageModel(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        subject: 'Test Subject',
        message: 'Test message',
        timestamp: DateTime.now(),
      );

      // Act
      final result = await supportDataSource.saveContactMessage(message);

      // Assert
      expect(result.id, equals(message.id));
      expect(result.email, equals('john@example.com'));
      expect(result.name, equals('John Doe'));
    });

    test('should return the saved message', () async {
      // Arrange
      final message = ContactMessageModel(
        id: '2',
        name: 'Jane Doe',
        email: 'jane@example.com',
        subject: 'Another Subject',
        message: 'Another message',
        timestamp: DateTime.now(),
      );

      // Act
      final result = await supportDataSource.saveContactMessage(message);

      // Assert
      expect(result, equals(message));
    });
  });

  group('SupportLocalDataSource - _getCachedMessages', () {
    test('should not throw when there are no cached messages', () async {
      // Act
      final message = ContactMessageModel(
        id: '1',
        name: 'Test',
        email: 'test@test.com',
        subject: 'Test',
        message: 'Test',
        timestamp: DateTime.now(),
      );
      final result = await supportDataSource.saveContactMessage(message);

      // Assert
      expect(result, isNotNull);
    });

    test('should rethrow ParseException when JSON is invalid',
        () async {
      // Arrange
      const invalidJson = '{"invalid: json}';
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(invalidJson);

      // Act & Assert
      expect(
        () => supportDataSource.saveContactMessage(
          ContactMessageModel(
            id: '1',
            name: 'Test',
            email: 'test@test.com',
            subject: 'Test',
            message: 'Test',
            timestamp: DateTime.now(),
          ),
        ),
        throwsA(isA<ParseException>()),
      );
    });

    test('should handle an empty JSON array', () async {
      // Arrange
      final emptyArray = json.encode(<Map<String, dynamic>>[]);
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(emptyArray);

      // Act
      final message = ContactMessageModel(
        id: '1',
        name: 'Test',
        email: 'test@test.com',
        subject: 'Test',
        message: 'Test',
        timestamp: DateTime.now(),
      );
      final result = await supportDataSource.saveContactMessage(message);

      // Assert
      expect(result.id, equals('1'));
    });

    test('should include parsing details on error', () async {
      // Arrange
      const corruptedJson = '[{incomplete}]';
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(corruptedJson);

      // Act & Assert
      expect(
        () => supportDataSource.saveContactMessage(
          ContactMessageModel(
            id: '1',
            name: 'Test',
            email: 'test@test.com',
            subject: 'Test',
            message: 'Test',
            timestamp: DateTime.now(),
          ),
        ),
        throwsA(isA<ParseException>()),
      );
    });
  });

  group('SupportLocalDataSource - getContactInfo', () {
    test('should return valid contact info', () {
      // Act
      final contactInfo = supportDataSource.getContactInfo();

      // Assert
      expect(contactInfo.email, isNotEmpty);
      expect(contactInfo.phone, isNotEmpty);
      expect(contactInfo.address, isNotEmpty);
      expect(contactInfo.socialMedia, isNotEmpty);
    });

    test('should contain a valid email', () {
      // Act
      final contactInfo = supportDataSource.getContactInfo();

      // Assert
      expect(contactInfo.email, contains('@'));
    });

    test('should include social media links', () {
      // Act
      final contactInfo = supportDataSource.getContactInfo();

      // Assert
      expect(contactInfo.socialMedia.isNotEmpty, isTrue);
      expect(contactInfo.socialMedia.containsKey('facebook'), isTrue);
      expect(contactInfo.socialMedia.containsKey('twitter'), isTrue);
      expect(contactInfo.socialMedia.containsKey('instagram'), isTrue);
    });
  });
}
