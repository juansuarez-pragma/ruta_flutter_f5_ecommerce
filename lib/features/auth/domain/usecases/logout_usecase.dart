import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';

/// Use case for logging out.
///
/// Encapsulates the business logic for ending the current user's session.
class LogoutUseCase {
  const LogoutUseCase({required this.repository});
  final AuthRepository repository;

  /// Executes the logout use case.
  ///
  /// Returns [Right<void>] when logout succeeds.
  /// Returns [Left<AuthFailure>] when there is an error.
  Future<Either<AuthFailure, void>> call() {
    return repository.logout();
  }
}
