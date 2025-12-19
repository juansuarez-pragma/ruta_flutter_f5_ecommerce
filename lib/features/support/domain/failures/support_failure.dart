import 'support_failure_type.dart';

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

