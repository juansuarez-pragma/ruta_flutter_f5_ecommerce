import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/auth/domain/entities/user.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';

/// Use case for registering a new user.
///
/// Encapsulates the business logic for creating a new user account.
class RegisterUseCase {
  const RegisterUseCase({required this.repository});
  final AuthRepository repository;

  /// Executes the registration use case.
  ///
  /// [email] - New user email.
  /// [password] - New user password.
  /// [username] - Unique username.
  /// [firstName] - First name.
  /// [lastName] - Last name.
  ///
  /// Returns [Right<User>] when registration succeeds.
  /// Returns [Left<AuthFailure>] when there is an error.
  Future<Either<AuthFailure, User>> call({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) {
    return repository.register(
      email: email,
      password: password,
      username: username,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
