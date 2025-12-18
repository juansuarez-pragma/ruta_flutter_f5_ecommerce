import 'package:equatable/equatable.dart';

/// Entity that represents a contact message.
class ContactMessage extends Equatable {
  const ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.timestamp,
  });

  /// Unique identifier.
  final String id;

  /// Sender name.
  final String name;

  /// Sender email.
  final String email;

  /// Subject.
  final String subject;

  /// Message body.
  final String message;

  /// Sent date and time.
  final DateTime timestamp;

  @override
  List<Object?> get props => [id, name, email, subject, message, timestamp];
}
