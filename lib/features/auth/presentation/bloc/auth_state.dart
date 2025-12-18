part of 'auth_bloc.dart';

/// Auth BLoC states.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state (auth check pending).
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state during auth operations.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when the user is authenticated.
final class AuthAuthenticated extends AuthState {

  const AuthAuthenticated({required this.user});
  final User user;

  @override
  List<Object?> get props => [user];
}

/// State when there is no authenticated user.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state during auth operations.
final class AuthError extends AuthState {

  const AuthError({
    required this.message,
    this.failureType,
  });
  final String message;
  final AuthFailureType? failureType;

  @override
  List<Object?> get props => [message, failureType];
}
