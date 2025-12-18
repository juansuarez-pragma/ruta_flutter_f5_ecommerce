import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/support/domain/entities/contact_message.dart';
import 'package:ecommerce/features/support/domain/repositories/support_repository.dart';

/// Use case for sending a contact message.
class SendContactMessageUseCase {
  const SendContactMessageUseCase({required this.repository});

  final SupportRepository repository;

  /// Runs the use case.
  ///
  /// Validates the fields before sending.
  Future<Either<SupportFailure, ContactMessage>> call({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();
    final trimmedSubject = subject.trim();
    final trimmedMessage = message.trim();

    // Validations
    if (trimmedName.isEmpty) {
      return Left(SupportFailure.validationFailed('Name is required'));
    }

    if (trimmedEmail.isEmpty) {
      return Left(SupportFailure.validationFailed('Email is required'));
    }

    if (!_isValidEmail(trimmedEmail)) {
      return Left(SupportFailure.validationFailed('Email is not valid'));
    }

    if (trimmedSubject.isEmpty) {
      return Left(SupportFailure.validationFailed('Subject is required'));
    }

    if (trimmedMessage.isEmpty) {
      return Left(SupportFailure.validationFailed('Message is required'));
    }

    if (trimmedMessage.length < 10) {
      return Left(SupportFailure.validationFailed(
        'Message must be at least 10 characters',
      ));
    }

    return repository.sendContactMessage(
      name: trimmedName,
      email: trimmedEmail,
      subject: trimmedSubject,
      message: trimmedMessage,
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
