import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/support/domain/entities/contact_message.dart';
import 'package:ecommerce/features/support/domain/repositories/support_repository.dart';

/// Caso de uso para enviar un mensaje de contacto.
class SendContactMessageUseCase {
  const SendContactMessageUseCase({required this.repository});

  final SupportRepository repository;

  /// Ejecuta el caso de uso.
  ///
  /// Valida los campos antes de enviar.
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

    // Validaciones
    if (trimmedName.isEmpty) {
      return Left(SupportFailure.validationFailed('El nombre es requerido'));
    }

    if (trimmedEmail.isEmpty) {
      return Left(SupportFailure.validationFailed('El email es requerido'));
    }

    if (!_isValidEmail(trimmedEmail)) {
      return Left(SupportFailure.validationFailed('El email no es válido'));
    }

    if (trimmedSubject.isEmpty) {
      return Left(SupportFailure.validationFailed('El asunto es requerido'));
    }

    if (trimmedMessage.isEmpty) {
      return Left(SupportFailure.validationFailed('El mensaje es requerido'));
    }

    if (trimmedMessage.length < 10) {
      return Left(SupportFailure.validationFailed(
        'El mensaje debe tener al menos 10 caracteres',
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
