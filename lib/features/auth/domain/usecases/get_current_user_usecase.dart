import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/auth/domain/entities/user.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para obtener el usuario actual.
///
/// Encapsula la lógica de negocio para recuperar la información
/// del usuario actualmente autenticado.
class GetCurrentUserUseCase {

  const GetCurrentUserUseCase({required this.repository});
  final AuthRepository repository;

  /// Ejecuta el caso de uso para obtener el usuario actual.
  ///
  /// Retorna [Right<User>] si hay un usuario autenticado.
  /// Retorna [Left<AuthFailure>] si no hay sesión activa.
  Future<Either<AuthFailure, User>> call() {
    return repository.getCurrentUser();
  }
}
