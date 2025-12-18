import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/core/error_handling/error_logger.dart';
import 'package:ecommerce/core/error_handling/error_handling_utils.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_storage_keys.dart';
import 'package:ecommerce/features/auth/data/errors/auth_local_exception.dart';
import 'package:ecommerce/features/auth/data/models/user_model.dart';

/// Implementación de [AuthLocalDataSource] usando SharedPreferences.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<void> cacheCurrentUser(UserModel user) async {
    final userJson = json.encode(user.toJson());
    await sharedPreferences.setString(AuthStorageKeys.currentUser, userJson);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userJson = sharedPreferences.getString(AuthStorageKeys.currentUser);
    if (userJson == null) return null;

    try {
      final userMap = safeJsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } on ParseException {
      rethrow;
    } catch (e, st) {
      final exception = ParseException(
        message: 'Error al cargar usuario cacheado',
        failedValue: userJson.length > 200
            ? '${userJson.substring(0, 200)}...'
            : userJson,
        originalException: e is Exception ? e : Exception(e.toString()),
      );

      ErrorLogger().logAppException(
        exception,
        context: {'operation': 'getCachedUser'},
        stackTrace: st,
      );

      throw exception;
    }
  }

  @override
  Future<void> clearCurrentUser() async {
    await sharedPreferences.remove(AuthStorageKeys.currentUser);
  }

  @override
  Future<UserModel> registerUser({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) async {
    if (await isEmailRegistered(email)) {
      throw const AuthLocalException('Email already registered');
    }

    final users = await _getRegisteredUsers();

    final newId = users.isEmpty
        ? 1
        : users.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1;

    final token = _generateToken(email);

    final newUser = UserModel(
      id: newId,
      email: email,
      username: username,
      firstName: firstName,
      lastName: lastName,
      token: token,
    );

    final usersWithPassword = await _getRegisteredUsersWithPasswords();
    usersWithPassword.add({
      'user': newUser.toJson(),
      'password': _hashPassword(password),
    });
    await _saveRegisteredUsers(usersWithPassword);

    return newUser;
  }

  @override
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final usersWithPassword = await _getRegisteredUsersWithPasswords();

    for (final entry in usersWithPassword) {
      final userJson = entry['user'] as Map<String, dynamic>;
      final storedPasswordHash = entry['password'] as String;

      if (userJson['email'] == email &&
          storedPasswordHash == _hashPassword(password)) {
        final user = UserModel.fromJson(userJson);
        final token = _generateToken(email);
        return user.copyWithToken(token);
      }
    }

    return null;
  }

  @override
  Future<bool> isEmailRegistered(String email) async {
    final users = await _getRegisteredUsers();
    return users.any((user) => user.email == email);
  }

  Future<List<UserModel>> _getRegisteredUsers() async {
    final usersWithPassword = await _getRegisteredUsersWithPasswords();
    return usersWithPassword.map((entry) {
      final userJson = entry['user'] as Map<String, dynamic>;
      return UserModel.fromJson(userJson);
    }).toList();
  }

  Future<List<Map<String, dynamic>>> _getRegisteredUsersWithPasswords() async {
    final usersJson = sharedPreferences.getString(AuthStorageKeys.registeredUsers);
    if (usersJson == null) return [];

    try {
      final usersList = safeJsonDecode(usersJson) as List<dynamic>;

      for (final item in usersList) {
        if (item is! Map<String, dynamic>) {
          throw ParseException(
            message: 'Elemento de usuario no es un Map válido',
            failedValue: item.toString(),
          );
        }
      }

      return usersList.cast<Map<String, dynamic>>();
    } on ParseException {
      ErrorLogger().logError(
        message: 'Error al decodificar lista de usuarios registrados',
        context: {'operation': '_getRegisteredUsersWithPasswords'},
      );
      rethrow;
    } catch (e, st) {
      final exception = ParseException(
        message: 'Error inesperado al cargar usuarios registrados',
        failedValue: usersJson.length > 200
            ? '${usersJson.substring(0, 200)}...'
            : usersJson,
        originalException: e is Exception ? e : Exception(e.toString()),
      );

      ErrorLogger().logAppException(
        exception,
        context: {'operation': '_getRegisteredUsersWithPasswords'},
        stackTrace: st,
      );

      throw exception;
    }
  }

  Future<void> _saveRegisteredUsers(List<Map<String, dynamic>> users) async {
    final usersJson = json.encode(users);
    await sharedPreferences.setString(AuthStorageKeys.registeredUsers, usersJson);
  }

  String _generateToken(String email) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return base64.encode(utf8.encode('$email:$timestamp'));
  }

  String _hashPassword(String password) {
    return base64.encode(utf8.encode(password));
  }
}
