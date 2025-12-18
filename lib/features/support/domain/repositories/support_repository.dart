import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/support/domain/entities/contact_info.dart';
import 'package:ecommerce/features/support/domain/entities/faq_item.dart';
import 'package:ecommerce/features/support/domain/entities/contact_message.dart';

/// Support failure types.
enum SupportFailureType {
  /// Failed to load FAQs.
  loadFaqsFailed,

  /// Failed to send a message.
  sendMessageFailed,

  /// Validation failed.
  validationFailed,

  /// Unknown error.
  unknown,
}

/// Represents a failure in support operations.
class SupportFailure {
  const SupportFailure({
    required this.type,
    required this.message,
  });

  factory SupportFailure.loadFaqsFailed() => const SupportFailure(
    type: SupportFailureType.loadFaqsFailed,
    message: 'Failed to load FAQs',
  );

  factory SupportFailure.sendMessageFailed() => const SupportFailure(
    type: SupportFailureType.sendMessageFailed,
    message: 'Failed to send message. Please try again.',
  );

  factory SupportFailure.validationFailed(String message) => SupportFailure(
    type: SupportFailureType.validationFailed,
    message: message,
  );

  factory SupportFailure.unknown([String? message]) => SupportFailure(
    type: SupportFailureType.unknown,
    message: message ?? 'An unexpected error occurred',
  );

  final SupportFailureType type;
  final String message;
}

/// Abstract repository for support operations.
abstract class SupportRepository {
  /// Returns the FAQ list.
  Future<Either<SupportFailure, List<FAQItem>>> getFAQs();

  /// Returns FAQs filtered by category.
  Future<Either<SupportFailure, List<FAQItem>>> getFAQsByCategory(
    FAQCategory category,
  );

  /// Sends a contact message.
  Future<Either<SupportFailure, ContactMessage>> sendContactMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  });

  /// Returns store contact information.
  Future<Either<SupportFailure, ContactInfo>> getContactInfo();
}
