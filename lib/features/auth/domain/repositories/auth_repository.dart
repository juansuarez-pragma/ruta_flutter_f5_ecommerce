import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/auth/domain/entities/user.dart';

/// Tipos de errores de autenticación.
enum AuthFailureType {
  /// Credenciales inválidas (email/password incorrectos).
  invalidCredentials,

  /// Email ya registrado.
  emailAlreadyInUse,

  /// Contraseña débil.
  weakPassword,

  /// Email inválido.
  invalidEmail,

  /// Usuario no encontrado.
  userNotFound,

  /// Error de conexión.
  connectionError,

  /// Error desconocido.
  unknown,
}

/// Representa un fallo de autenticación.
class AuthFailure {

  const AuthFailure({
    required this.type,
    required this.message,
  });

  factory AuthFailure.invalidCredentials() => const AuthFailure(
    type: AuthFailureType.invalidCredentials,
    message: 'Email o contraseña incorrectos',
  );

  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
    type: AuthFailureType.emailAlreadyInUse,
    message: 'Este email ya está registrado',
  );

  factory AuthFailure.weakPassword() => const AuthFailure(
    type: AuthFailureType.weakPassword,
    message: 'La contraseña debe tener al menos 6 caracteres',
  );

  factory AuthFailure.invalidEmail() => const AuthFailure(
    type: AuthFailureType.invalidEmail,
    message: 'El formato del email es inválido',
  );

  factory AuthFailure.userNotFound() => const AuthFailure(
    type: AuthFailureType.userNotFound,
    message: 'Usuario no encontrado',
  );

  factory AuthFailure.connectionError() => const AuthFailure(
    type: AuthFailureType.connectionError,
    message: 'Error de conexión. Verifica tu internet.',
  );

  factory AuthFailure.unknown([String? message]) => AuthFailure(
    type: AuthFailureType.unknown,
    message: message ?? 'Ha ocurrido un error inesperado',
  );
  final AuthFailureType type;
  final String message;
}

/// Repositorio abstracto para operaciones de autenticación.
///
/// Define el contrato que debe implementar cualquier fuente de datos
/// de autenticación (local, remota, etc.).
abstract class AuthRepository {
  /// Inicia sesión con email y contraseña.
  ///
  /// Retorna [Right<User>] si el login es exitoso.
  /// Retorna [Left<AuthFailure>] si hay un error.
  Future<Either<AuthFailure, User>> login({
    required String email,
    required String password,
  });

  /// Registra un nuevo usuario.
  ///
  /// Retorna [Right<User>] si el registro es exitoso.
  /// Retorna [Left<AuthFailure>] si hay un error.
  Future<Either<AuthFailure, User>> register({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  });

  /// Cierra la sesión del usuario actual.
  ///
  /// Retorna [Right<void>] si el logout es exitoso.
  /// Retorna [Left<AuthFailure>] si hay un error.
  Future<Either<AuthFailure, void>> logout();

  /// Obtiene el usuario actualmente autenticado.
  ///
  /// Retorna [Right<User>] si hay un usuario autenticado.
  /// Retorna [Left<AuthFailure>] si no hay sesión activa.
  Future<Either<AuthFailure, User>> getCurrentUser();

  /// Verifica si hay una sesión activa.
  Future<bool> isAuthenticated();
}
