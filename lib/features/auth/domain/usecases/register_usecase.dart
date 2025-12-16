import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/auth/domain/entities/user.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para registrar un nuevo usuario.
///
/// Encapsula la lógica de negocio para crear una nueva cuenta
/// de usuario en el sistema.
class RegisterUseCase {

  const RegisterUseCase({required this.repository});
  final AuthRepository repository;

  /// Ejecuta el caso de uso de registro.
  ///
  /// [email] - Email del nuevo usuario.
  /// [password] - Contraseña del nuevo usuario.
  /// [username] - Nombre de usuario único.
  /// [firstName] - Nombre del usuario.
  /// [lastName] - Apellido del usuario.
  ///
  /// Retorna [Right<User>] si el registro es exitoso.
  /// Retorna [Left<AuthFailure>] si hay un error.
  Future<Either<AuthFailure, User>> call({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) {
    return repository.register(
      email: email,
      password: password,
      username: username,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
