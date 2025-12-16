import 'package:equatable/equatable.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';
import 'package:ecommerce/features/support/domain/repositories/support_repository.dart';

/// Estados del BLoC de soporte.
sealed class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial.
final class SupportInitial extends SupportState {
  const SupportInitial();
}

/// Estado de carga.
final class SupportLoading extends SupportState {
  const SupportLoading();
}

/// Estado cuando las FAQs se cargaron exitosamente.
final class SupportFAQsLoaded extends SupportState {
  const SupportFAQsLoaded({
    required this.faqs,
    this.selectedCategory,
  });

  final List<FAQItem> faqs;
  final FAQCategory? selectedCategory;

  @override
  List<Object?> get props => [faqs, selectedCategory];
}

/// Estado cuando el mensaje de contacto se envió exitosamente.
final class SupportMessageSent extends SupportState {
  const SupportMessageSent();
}

/// Estado cuando la información de contacto se cargó.
final class SupportContactInfoLoaded extends SupportState {
  const SupportContactInfoLoaded({required this.contactInfo});

  final ContactInfo contactInfo;

  @override
  List<Object?> get props => [contactInfo];
}

/// Estado de error.
final class SupportError extends SupportState {
  const SupportError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
