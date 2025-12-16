import 'package:ecommerce/features/support/domain/entities/contact_message.dart';

/// Modelo de datos para ContactMessage con serialización JSON.
class ContactMessageModel extends ContactMessage {
  const ContactMessageModel({
    required super.id,
    required super.name,
    required super.email,
    required super.subject,
    required super.message,
    required super.timestamp,
  });

  /// Crea una instancia desde JSON.
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

  /// Convierte la instancia a JSON.
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

  /// Crea una instancia desde una entidad del dominio.
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

  /// Convierte el modelo a entidad del dominio.
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
