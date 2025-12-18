import 'package:equatable/equatable.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';

/// Support BLoC events.
sealed class SupportEvent extends Equatable {
  const SupportEvent();

  @override
  List<Object?> get props => [];
}

/// Requests loading FAQs.
final class SupportFAQsLoadRequested extends SupportEvent {
  const SupportFAQsLoadRequested({this.category});

  final FAQCategory? category;

  @override
  List<Object?> get props => [category];
}

/// Requests sending a contact message.
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

/// Requests loading contact information.
final class SupportContactInfoLoadRequested extends SupportEvent {
  const SupportContactInfoLoadRequested();
}
