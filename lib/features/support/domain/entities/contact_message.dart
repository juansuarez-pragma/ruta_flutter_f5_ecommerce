import 'package:equatable/equatable.dart';

/// Entidad que representa un mensaje de contacto.
class ContactMessage extends Equatable {
  const ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.timestamp,
  });

  /// Identificador único del mensaje.
  final String id;

  /// Nombre del remitente.
  final String name;

  /// Email del remitente.
  final String email;

  /// Asunto del mensaje.
  final String subject;

  /// Contenido del mensaje.
  final String message;

  /// Fecha y hora de envío.
  final DateTime timestamp;

  @override
  List<Object?> get props => [id, name, email, subject, message, timestamp];
}
