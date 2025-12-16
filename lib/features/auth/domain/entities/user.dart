import 'package:equatable/equatable.dart';

/// Entidad de usuario del dominio.
///
/// Representa un usuario autenticado en el sistema.
class User extends Equatable {

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.token,
  });
  /// Identificador único del usuario.
  final int id;

  /// Correo electrónico del usuario.
  final String email;

  /// Nombre de usuario.
  final String username;

  /// Nombre completo del usuario.
  final String firstName;

  /// Apellido del usuario.
  final String lastName;

  /// Token de autenticación (opcional, usado para sesiones activas).
  final String? token;

  /// Nombre completo formateado.
  String get fullName => '$firstName $lastName';

  /// Verifica si el usuario tiene un token válido.
  bool get isAuthenticated => token != null && token!.isNotEmpty;

  /// Crea una copia del usuario con cambios opcionales.
  User copyWith({
    int? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [id, email, username, firstName, lastName, token];
}
