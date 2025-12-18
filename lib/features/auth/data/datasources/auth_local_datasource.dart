import 'package:ecommerce/features/auth/data/models/user_model.dart';

/// DataSource local para operaciones de autenticación.
///
/// Implementa almacenamiento de usuarios en SharedPreferences
/// para funcionar sin dependencia de API externa.
abstract class AuthLocalDataSource {
  /// Guarda el usuario actual en almacenamiento local.
  Future<void> cacheCurrentUser(UserModel user);

  /// Obtiene el usuario actual del almacenamiento local.
  Future<UserModel?> getCachedUser();

  /// Elimina el usuario actual del almacenamiento.
  Future<void> clearCurrentUser();

  /// Registra un nuevo usuario localmente.
  Future<UserModel> registerUser({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  });

  /// Verifica credenciales de login contra usuarios registrados.
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  });

  /// Verifica si un email ya está registrado.
  Future<bool> isEmailRegistered(String email);
}
