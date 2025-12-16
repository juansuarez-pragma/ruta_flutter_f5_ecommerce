part of 'auth_bloc.dart';

/// Eventos del BLoC de autenticación.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para verificar el estado de autenticación al iniciar la app.
final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Evento para iniciar sesión.
final class AuthLoginRequested extends AuthEvent {

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Evento para registrar un nuevo usuario.
final class AuthRegisterRequested extends AuthEvent {

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.username,
    required this.firstName,
    required this.lastName,
  });
  final String email;
  final String password;
  final String username;
  final String firstName;
  final String lastName;

  @override
  List<Object?> get props => [email, password, username, firstName, lastName];
}

/// Evento para cerrar sesión.
final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
