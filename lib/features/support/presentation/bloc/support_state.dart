import 'package:equatable/equatable.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';
import 'package:ecommerce/features/support/domain/entities/contact_info.dart';

/// Support BLoC states.
sealed class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
final class SupportInitial extends SupportState {
  const SupportInitial();
}

/// Loading state.
final class SupportLoading extends SupportState {
  const SupportLoading();
}

/// State when FAQs were loaded successfully.
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

/// State when a contact message was sent successfully.
final class SupportMessageSent extends SupportState {
  const SupportMessageSent();
}

/// State when contact information was loaded.
final class SupportContactInfoLoaded extends SupportState {
  const SupportContactInfoLoaded({required this.contactInfo});

  final ContactInfo contactInfo;

  @override
  List<Object?> get props => [contactInfo];
}

/// Error state.
final class SupportError extends SupportState {
  const SupportError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
