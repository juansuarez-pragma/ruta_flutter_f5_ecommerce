import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';

/// Caso de uso para cerrar sesión.
///
/// Encapsula la lógica de negocio para terminar la sesión
/// del usuario actual.
class LogoutUseCase {

  const LogoutUseCase({required this.repository});
  final AuthRepository repository;

  /// Ejecuta el caso de uso de logout.
  ///
  /// Retorna [Right<void>] si el logout es exitoso.
  /// Retorna [Left<AuthFailure>] si hay un error.
  Future<Either<AuthFailure, void>> call() {
    return repository.logout();
  }
}
