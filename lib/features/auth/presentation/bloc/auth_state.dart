part of 'auth_bloc.dart';

/// Estados del BLoC de autenticación.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial, verificando autenticación.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Estado de carga durante operaciones de auth.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Estado cuando el usuario está autenticado.
final class AuthAuthenticated extends AuthState {

  const AuthAuthenticated({required this.user});
  final User user;

  @override
  List<Object?> get props => [user];
}

/// Estado cuando no hay usuario autenticado.
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Estado de error en operaciones de auth.
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
