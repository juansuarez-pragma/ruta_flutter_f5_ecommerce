import 'package:flutter_test/flutter_test.dart';
import 'package:ecommerce/features/support/support.dart';

void main() {
  group('ContactMessage Entity', () {
    final tTimestamp = DateTime(2025, 12, 16, 10, 30);
    final tContactMessage = ContactMessage(
      id: '1',
      name: 'Test User',
      email: 'test@example.com',
      subject: 'Consulta sobre producto',
      message: 'Me gustaría saber más sobre el producto X.',
      timestamp: tTimestamp,
    );

    test('should be a valid ContactMessage', () {
      expect(tContactMessage.id, '1');
      expect(tContactMessage.name, 'Test User');
      expect(tContactMessage.email, 'test@example.com');
      expect(tContactMessage.subject, 'Consulta sobre producto');
      expect(tContactMessage.timestamp, tTimestamp);
    });

    test('two ContactMessages with same properties should be equal', () {
      final message1 = ContactMessage(
        id: '1',
        name: 'User',
        email: 'user@test.com',
        subject: 'Subject',
        message: 'Message',
        timestamp: tTimestamp,
      );

      final message2 = ContactMessage(
        id: '1',
        name: 'User',
        email: 'user@test.com',
        subject: 'Subject',
        message: 'Message',
        timestamp: tTimestamp,
      );

      expect(message1, message2);
    });

    test('two ContactMessages with different properties should not be equal', () {
      final message1 = ContactMessage(
        id: '1',
        name: 'User 1',
        email: 'user1@test.com',
        subject: 'Subject',
        message: 'Message',
        timestamp: tTimestamp,
      );

      final message2 = ContactMessage(
        id: '2',
        name: 'User 2',
        email: 'user2@test.com',
        subject: 'Subject',
        message: 'Message',
        timestamp: tTimestamp,
      );

      expect(message1, isNot(message2));
    });

    test('props should contain all properties', () {
      expect(tContactMessage.props, [
        tContactMessage.id,
        tContactMessage.name,
        tContactMessage.email,
        tContactMessage.subject,
        tContactMessage.message,
        tContactMessage.timestamp,
      ]);
    });
  });
}
