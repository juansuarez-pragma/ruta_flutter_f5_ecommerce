import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/auth/domain/entities/user.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para iniciar sesión.
///
/// Encapsula la lógica de negocio para autenticar un usuario
/// con email y contraseña.
class LoginUseCase {

  const LoginUseCase({required this.repository});
  final AuthRepository repository;

  /// Ejecuta el caso de uso de login.
  ///
  /// [email] - Email del usuario.
  /// [password] - Contraseña del usuario.
  ///
  /// Retorna [Right<User>] si el login es exitoso.
  /// Retorna [Left<AuthFailure>] si hay un error.
  Future<Either<AuthFailure, User>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
