import 'auth_failure_type.dart';

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

