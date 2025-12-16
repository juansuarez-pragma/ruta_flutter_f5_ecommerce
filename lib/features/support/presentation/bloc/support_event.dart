import 'package:equatable/equatable.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';

/// Eventos del BLoC de soporte.
sealed class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar las FAQs.
final class SupportFAQsLoadRequested extends SupportEvent {
  const SupportFAQsLoadRequested({this.category});

  final FAQCategory? category;

  @override
  List<Object?> get props => [category];
}

/// Evento para enviar un mensaje de contacto.
final class SupportContactMessageSent extends SupportEvent {
  const SupportContactMessageSent({
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
  });

  final String name;
  final String email;
  final String subject;
  final String message;

  @override
  List<Object?> get props => [name, email, subject, message];
}

/// Evento para cargar la información de contacto.
final class SupportContactInfoLoadRequested extends SupportEvent {
  const SupportContactInfoLoadRequested();
}
