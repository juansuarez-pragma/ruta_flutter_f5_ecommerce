import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:ecommerce/features/support/domain/entities/faq_item.dart';
import 'package:ecommerce/features/support/domain/entities/contact_message.dart';

/// Tipos de errores de soporte.
enum SupportFailureType {
  /// Error al cargar FAQs.
  loadFaqsFailed,

  /// Error al enviar mensaje.
  sendMessageFailed,

  /// Validación fallida.
  validationFailed,

  /// Error desconocido.
  unknown,
}

/// Representa un fallo en operaciones de soporte.
class SupportFailure {
  const SupportFailure({
    required this.type,
    required this.message,
  });

  factory SupportFailure.loadFaqsFailed() => const SupportFailure(
    type: SupportFailureType.loadFaqsFailed,
    message: 'No se pudieron cargar las preguntas frecuentes',
  );

  factory SupportFailure.sendMessageFailed() => const SupportFailure(
    type: SupportFailureType.sendMessageFailed,
    message: 'No se pudo enviar el mensaje. Intenta de nuevo.',
  );

  factory SupportFailure.validationFailed(String message) => SupportFailure(
    type: SupportFailureType.validationFailed,
    message: message,
  );

  factory SupportFailure.unknown([String? message]) => SupportFailure(
    type: SupportFailureType.unknown,
    message: message ?? 'Ha ocurrido un error inesperado',
  );

  final SupportFailureType type;
  final String message;
}

/// Repositorio abstracto para operaciones de soporte.
abstract class SupportRepository {
  /// Obtiene la lista de preguntas frecuentes.
  Future<Either<SupportFailure, List<FAQItem>>> getFAQs();

  /// Obtiene FAQs filtradas por categoría.
  Future<Either<SupportFailure, List<FAQItem>>> getFAQsByCategory(
    FAQCategory category,
  );

  /// Envía un mensaje de contacto.
  Future<Either<SupportFailure, ContactMessage>> sendContactMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  });

  /// Obtiene información de contacto de la tienda.
  Future<Either<SupportFailure, ContactInfo>> getContactInfo();
}

/// Información de contacto de la tienda.
class ContactInfo extends Equatable {
  const ContactInfo({
    required this.email,
    required this.phone,
    required this.address,
    this.socialMedia = const {},
  });

  final String email;
  final String phone;
  final String address;
  final Map<String, String> socialMedia;

  @override
  List<Object?> get props => [email, phone, address, socialMedia];
}
