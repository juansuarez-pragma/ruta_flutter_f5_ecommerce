import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/auth/domain/entities/user.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';

/// Use case for signing in.
///
/// Encapsulates the business logic for authenticating a user with email and
/// password.
class LoginUseCase {
  const LoginUseCase({required this.repository});
  final AuthRepository repository;

  /// Executes the sign-in use case.
  ///
  /// [email] - User email.
  /// [password] - User password.
  ///
  /// Returns [Right<User>] when sign-in succeeds.
  /// Returns [Left<AuthFailure>] when there is an error.
  Future<Either<AuthFailure, User>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
