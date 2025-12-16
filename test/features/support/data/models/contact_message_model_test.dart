import 'package:flutter_test/flutter_test.dart';

import 'package:ecommerce/features/support/data/models/contact_message_model.dart';
import 'package:ecommerce/features/support/domain/entities/contact_message.dart';
import '../../../../helpers/mocks.dart';

void main() {
  final tContactMessageModel = ContactMessageModel(
    id: '1',
    name: ContactMessageFixtures.validName,
    email: ContactMessageFixtures.validEmail,
    subject: ContactMessageFixtures.validSubject,
    message: ContactMessageFixtures.validMessage,
    timestamp: ContactMessageFixtures.sampleTimestamp,
  );

  group('ContactMessageModel', () {
    test('should be a subclass of ContactMessage entity', () {
      expect(tContactMessageModel, isA<ContactMessage>());
    });

    group('fromJson', () {
      test('should return a valid model', () {
        // Arrange
        final json = ContactMessageFixtures.sampleContactMessageJson;

        // Act
        final result = ContactMessageModel.fromJson(json);

        // Assert
        expect(result, tContactMessageModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing proper data', () {
        // Act
        final result = tContactMessageModel.toJson();

        // Assert
        expect(result['id'], '1');
        expect(result['name'], ContactMessageFixtures.validName);
        expect(result['email'], ContactMessageFixtures.validEmail);
        expect(result['subject'], ContactMessageFixtures.validSubject);
        expect(result['message'], ContactMessageFixtures.validMessage);
        expect(result['timestamp'], ContactMessageFixtures.sampleTimestamp.toIso8601String());
      });
    });

    group('toEntity', () {
      test('should return a ContactMessage entity with the same values', () {
        // Act
        final result = tContactMessageModel.toEntity();

        // Assert
        expect(result, isA<ContactMessage>());
        expect(result.id, tContactMessageModel.id);
        expect(result.name, tContactMessageModel.name);
        expect(result.email, tContactMessageModel.email);
        expect(result.subject, tContactMessageModel.subject);
        expect(result.message, tContactMessageModel.message);
        expect(result.timestamp, tContactMessageModel.timestamp);
      });
    });

    group('fromEntity', () {
      test('should return a ContactMessageModel from a ContactMessage entity', () {
        // Arrange
        final entity = ContactMessage(
          id: '2',
          name: 'Test User',
          email: 'test@test.com',
          subject: 'Test Subject',
          message: 'Test message content',
          timestamp: DateTime(2025, 1, 1),
        );

        // Act
        final result = ContactMessageModel.fromEntity(entity);

        // Assert
        expect(result, isA<ContactMessageModel>());
        expect(result.id, entity.id);
        expect(result.name, entity.name);
        expect(result.email, entity.email);
        expect(result.subject, entity.subject);
        expect(result.message, entity.message);
        expect(result.timestamp, entity.timestamp);
      });
    });
  });
}
