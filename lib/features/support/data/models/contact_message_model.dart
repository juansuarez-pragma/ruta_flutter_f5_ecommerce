import 'package:ecommerce/features/support/domain/entities/contact_message.dart';

/// ContactMessage data model with JSON serialization.
class ContactMessageModel extends ContactMessage {
  const ContactMessageModel({
    required super.id,
    required super.name,
    required super.email,
    required super.subject,
    required super.message,
    required super.timestamp,
  });

  /// Creates an instance from JSON.
  factory ContactMessageModel.fromJson(Map<String, dynamic> json) {
    return ContactMessageModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      subject: json['subject'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Creates an instance from a domain entity.
  factory ContactMessageModel.fromEntity(ContactMessage entity) {
    return ContactMessageModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      subject: entity.subject,
      message: entity.message,
      timestamp: entity.timestamp,
    );
  }

  /// Converts the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Converts the model to a domain entity.
  ContactMessage toEntity() {
    return ContactMessage(
      id: id,
      name: name,
      email: email,
      subject: subject,
      message: message,
      timestamp: timestamp,
    );
  }
}
