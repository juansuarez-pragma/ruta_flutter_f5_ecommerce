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
    // Validaciones
    if (name.trim().isEmpty) {
      return Left(SupportFailure.validationFailed('El nombre es requerido'));
    }

    if (email.trim().isEmpty) {
      return Left(SupportFailure.validationFailed('El email es requerido'));
    }

    if (!_isValidEmail(email)) {
      return Left(SupportFailure.validationFailed('El email no es válido'));
    }

    if (subject.trim().isEmpty) {
      return Left(SupportFailure.validationFailed('El asunto es requerido'));
    }

    if (message.trim().isEmpty) {
      return Left(SupportFailure.validationFailed('El mensaje es requerido'));
    }

    if (message.trim().length < 10) {
      return Left(SupportFailure.validationFailed(
        'El mensaje debe tener al menos 10 caracteres',
      ));
    }

    return repository.sendContactMessage(
      name: name.trim(),
      email: email.trim(),
      subject: subject.trim(),
      message: message.trim(),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
