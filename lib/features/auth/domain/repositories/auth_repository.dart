import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/auth/domain/entities/user.dart';

/// Authentication failure types.
enum AuthFailureType {
  /// Invalid credentials (incorrect email/password).
  invalidCredentials,

  /// Email already registered.
  emailAlreadyInUse,

  /// Weak password.
  weakPassword,

  /// Invalid email.
  invalidEmail,

  /// User not found.
  userNotFound,

  /// Connection error.
  connectionError,

  /// Unknown error.
  unknown,
}

/// Represents an authentication failure.
class AuthFailure {
  const AuthFailure({
    required this.type,
    required this.message,
  });

  factory AuthFailure.invalidCredentials() => const AuthFailure(
    type: AuthFailureType.invalidCredentials,
    message: 'Incorrect email or password',
  );

  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
    type: AuthFailureType.emailAlreadyInUse,
    message: 'This email is already registered',
  );

  factory AuthFailure.weakPassword() => const AuthFailure(
    type: AuthFailureType.weakPassword,
    message: 'Password must be at least 6 characters',
  );

  factory AuthFailure.invalidEmail() => const AuthFailure(
    type: AuthFailureType.invalidEmail,
    message: 'Email format is invalid',
  );

  factory AuthFailure.userNotFound() => const AuthFailure(
    type: AuthFailureType.userNotFound,
    message: 'User not found',
  );

  factory AuthFailure.connectionError() => const AuthFailure(
    type: AuthFailureType.connectionError,
    message: 'Connection error. Check your internet connection.',
  );

  factory AuthFailure.unknown([String? message]) => AuthFailure(
    type: AuthFailureType.unknown,
    message: message ?? 'An unexpected error occurred',
  );
  final AuthFailureType type;
  final String message;
}

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
