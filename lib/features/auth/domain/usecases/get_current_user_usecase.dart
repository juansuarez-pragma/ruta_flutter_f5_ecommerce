import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/auth/domain/entities/user.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';

/// Use case for getting the current user.
///
/// Encapsulates the business logic for retrieving the currently authenticated
/// user.
class GetCurrentUserUseCase {
  const GetCurrentUserUseCase({required this.repository});
  final AuthRepository repository;

  /// Executes the use case to retrieve the current user.
  ///
  /// Returns [Right<User>] when there is an authenticated user.
  /// Returns [Left<AuthFailure>] when there is no active session.
  Future<Either<AuthFailure, User>> call() {
    return repository.getCurrentUser();
  }
}
