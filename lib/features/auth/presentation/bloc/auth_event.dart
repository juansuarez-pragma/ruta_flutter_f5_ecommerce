part of 'auth_bloc.dart';

/// Auth BLoC events.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check authentication state on app start.
final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event to sign in.
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

/// Event to register a new user.
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

/// Event to sign out.
final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
