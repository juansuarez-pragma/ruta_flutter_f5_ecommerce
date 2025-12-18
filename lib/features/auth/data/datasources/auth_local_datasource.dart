import 'package:ecommerce/features/auth/data/models/user_model.dart';

/// Local data source for authentication operations.
///
/// Implements user storage using SharedPreferences to work without depending on
/// an external API.
abstract class AuthLocalDataSource {
  /// Stores the current user in local storage.
  Future<void> cacheCurrentUser(UserModel user);

  /// Retrieves the current user from local storage.
  Future<UserModel?> getCachedUser();

  /// Removes the current user from storage.
  Future<void> clearCurrentUser();

  /// Registers a new user locally.
  Future<UserModel> registerUser({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  });

  /// Checks login credentials against the registered users.
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  });

  /// Checks whether an email is already registered.
  Future<bool> isEmailRegistered(String email);
}
