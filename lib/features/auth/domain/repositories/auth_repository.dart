import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/auth/domain/entities/user.dart';
import 'package:ecommerce/features/auth/domain/failures/auth_failure.dart';

export 'package:ecommerce/features/auth/domain/failures/auth_failure.dart';
export 'package:ecommerce/features/auth/domain/failures/auth_failure_type.dart';

/// Abstract repository for authentication operations.
///
/// Defines the contract that any authentication data source (local, remote,
/// etc.) must implement.
abstract class AuthRepository {
  /// Signs in with email and password.
  ///
  /// Returns [Right<User>] when login succeeds.
  /// Returns [Left<AuthFailure>] when there is an error.
  Future<Either<AuthFailure, User>> login({
    required String email,
    required String password,
  });

  /// Registers a new user.
  ///
  /// Returns [Right<User>] when registration succeeds.
  /// Returns [Left<AuthFailure>] when there is an error.
  Future<Either<AuthFailure, User>> register({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  });

  /// Logs out the current user.
  ///
  /// Returns [Right<void>] when logout succeeds.
  /// Returns [Left<AuthFailure>] when there is an error.
  Future<Either<AuthFailure, void>> logout();

  /// Returns the currently authenticated user.
  ///
  /// Returns [Right<User>] when a user is authenticated.
  /// Returns [Left<AuthFailure>] when there is no active session.
  Future<Either<AuthFailure, User>> getCurrentUser();

  /// Checks whether there is an active session.
  Future<bool> isAuthenticated();
}
