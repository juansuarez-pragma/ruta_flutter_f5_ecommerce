import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/core/storage/secure_key_value_store.dart';
import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/core/error_handling/app_logger.dart';
import 'package:ecommerce/core/error_handling/error_handling_utils.dart';
import 'package:ecommerce/core/utils/id_generator.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_storage_keys.dart';
import 'package:ecommerce/features/auth/data/errors/auth_local_exception.dart';
import 'package:ecommerce/features/auth/data/models/registered_user_record.dart';
import 'package:ecommerce/features/auth/data/security/password_hasher.dart';
import 'package:ecommerce/features/auth/data/models/user_model.dart';

/// [AuthLocalDataSource] implementation using SharedPreferences.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required SharedPreferences legacySharedPreferences,
    required SecureKeyValueStore secureStore,
    required PasswordHasher passwordHasher,
    required IdGenerator tokenGenerator,
    required AppLogger logger,
  }) : _logger = logger,
       _legacySharedPreferences = legacySharedPreferences,
       _secureStore = secureStore,
       _passwordHasher = passwordHasher,
       _tokenGenerator = tokenGenerator;

  final SharedPreferences _legacySharedPreferences;
  final SecureKeyValueStore _secureStore;
  final PasswordHasher _passwordHasher;
  final IdGenerator _tokenGenerator;
  final AppLogger _logger;

  bool _migrated = false;

  Future<void> _ensureMigrated() async {
    if (_migrated) return;

    // Migrate current user from legacy SharedPreferences to secure storage.
    final legacyCurrentUser = _legacySharedPreferences.getString(
      AuthStorageKeys.currentUser,
    );
    if (legacyCurrentUser != null) {
      await _secureStore.write(AuthStorageKeys.currentUser, legacyCurrentUser);
      await _legacySharedPreferences.remove(AuthStorageKeys.currentUser);
    }

    // Migrate registered users from legacy SharedPreferences to secure storage.
    final legacyRegisteredUsersJson = _legacySharedPreferences.getString(
      AuthStorageKeys.registeredUsers,
    );

    if (legacyRegisteredUsersJson != null) {
      try {
        final usersList = safeJsonDecode(legacyRegisteredUsersJson) as List<dynamic>;

        final migratedRecords = <RegisteredUserRecord>[];

        for (final item in usersList) {
          if (item is! Map<String, dynamic>) {
            throw ParseException(
              message: 'Registered user record is not a valid Map',
              failedValue: item.toString(),
            );
          }

          final userJson = item['user'];
          final passwordValue = item['password'];

          if (userJson is! Map<String, dynamic>) {
            throw ParseException(
              message: 'Legacy registered user record "user" is not a valid Map',
              failedValue: userJson.toString(),
            );
          }

          if (passwordValue is! String) {
            throw ParseException(
              message:
                  'Legacy registered user record "password" is not a valid String',
              failedValue: passwordValue.toString(),
            );
          }

          final plainPassword = utf8.decode(base64.decode(passwordValue));
          final passwordHash = await _passwordHasher.hash(plainPassword);

          migratedRecords.add(
            RegisteredUserRecord(
              user: UserModel.fromJson(userJson).copyWithToken(null),
              passwordHash: passwordHash,
            ),
          );
        }

        await _saveRegisteredUserRecords(migratedRecords);
        await _legacySharedPreferences.remove(AuthStorageKeys.registeredUsers);
      } on ParseException {
        // Keep legacy data if it cannot be migrated, but do not crash startup.
        _logger.logError(
          message: 'Failed to migrate legacy registered users',
          context: {'operation': '_ensureMigrated'},
        );
      } catch (e, st) {
        _logger.logError(
          message: 'Unexpected error during legacy auth migration: $e',
          stackTrace: st,
          context: {'operation': '_ensureMigrated'},
        );
      }
    }

    _migrated = true;
  }

  @override
  Future<void> cacheCurrentUser(UserModel user) async {
    await _ensureMigrated();
    final userJson = json.encode(user.toJson());
    await _secureStore.write(AuthStorageKeys.currentUser, userJson);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    await _ensureMigrated();
    final userJson = await _secureStore.read(AuthStorageKeys.currentUser);
    if (userJson == null) return null;

    try {
      final userMap = safeJsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } on ParseException {
      rethrow;
    } catch (e, st) {
      final exception = ParseException(
        message: 'Failed to load cached user',
        failedValue: userJson.length > 200
            ? '${userJson.substring(0, 200)}...'
            : userJson,
        originalException: e is Exception ? e : Exception(e.toString()),
      );

      _logger.logAppException(
        exception,
        context: {'operation': 'getCachedUser'},
        stackTrace: st,
      );

      throw exception;
    }
  }

  @override
  Future<void> clearCurrentUser() async {
    await _ensureMigrated();
    await _secureStore.delete(AuthStorageKeys.currentUser);
  }

  @override
  Future<UserModel> registerUser({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) async {
    await _ensureMigrated();
    if (await isEmailRegistered(email)) {
      throw const AuthLocalException('Email already registered');
    }

    final registeredUsers = await _getRegisteredUsers();
    final nextUserId = _nextUserId(registeredUsers);
    final token = _generateSessionToken();

    final newUser = UserModel(
      id: nextUserId,
      email: email,
      username: username,
      firstName: firstName,
      lastName: lastName,
      token: token,
    );

    final registeredUserRecords = await _getRegisteredUserRecords();
    final passwordHash = await _passwordHasher.hash(password);
    registeredUserRecords.add(
      RegisteredUserRecord(
        user: newUser.copyWithToken(null),
        passwordHash: passwordHash,
      ),
    );
    await _saveRegisteredUserRecords(registeredUserRecords);

    return newUser;
  }

  @override
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    await _ensureMigrated();
    final registeredUserRecords = await _getRegisteredUserRecords();

    for (final record in registeredUserRecords) {
      final passwordMatches = await _passwordHasher.verify(
        password,
        record.passwordHash,
      );

      if (record.user.email == email && passwordMatches) {
        final user = record.user;
        final token = _generateSessionToken();
        return user.copyWithToken(token);
      }
    }

    return null;
  }

  @override
  Future<bool> isEmailRegistered(String email) async {
    await _ensureMigrated();
    final users = await _getRegisteredUsers();
    return users.any((user) => user.email == email);
  }

  Future<List<UserModel>> _getRegisteredUsers() async {
    final registeredUserRecords = await _getRegisteredUserRecords();
    return registeredUserRecords.map((record) => record.user).toList();
  }

  Future<List<RegisteredUserRecord>> _getRegisteredUserRecords() async {
    final usersJson = await _secureStore.read(AuthStorageKeys.registeredUsers);
    if (usersJson == null) return [];

    try {
      final usersList = safeJsonDecode(usersJson) as List<dynamic>;

      return usersList.map((item) {
        if (item is! Map<String, dynamic>) {
          throw ParseException(
            message: 'Registered user record is not a valid Map',
            failedValue: item.toString(),
          );
        }
        return RegisteredUserRecord.fromJson(item);
      }).toList();
    } on ParseException {
      _logger.logError(
        message: 'Failed to decode registered users list',
        context: {'operation': '_getRegisteredUserRecords'},
      );
      rethrow;
    } catch (e, st) {
      final exception = ParseException(
        message: 'Unexpected error while loading registered users',
        failedValue: usersJson.length > 200
            ? '${usersJson.substring(0, 200)}...'
            : usersJson,
        originalException: e is Exception ? e : Exception(e.toString()),
      );

      _logger.logAppException(
        exception,
        context: {'operation': '_getRegisteredUserRecords'},
        stackTrace: st,
      );

      throw exception;
    }
  }

  Future<void> _saveRegisteredUserRecords(
    List<RegisteredUserRecord> records,
  ) async {
    final usersJson = json.encode(records.map((r) => r.toJson()).toList());
    await _secureStore.write(AuthStorageKeys.registeredUsers, usersJson);
  }

  int _nextUserId(List<UserModel> existingUsers) {
    if (existingUsers.isEmpty) return 1;

    final maxExistingUserId = existingUsers
        .map((user) => user.id)
        .fold<int>(0, (maxSoFar, id) => id > maxSoFar ? id : maxSoFar);

    return maxExistingUserId + 1;
  }

  String _generateSessionToken() {
    // Opaque, unguessable token (UUID v4 by default).
    return _tokenGenerator.generate();
  }
}
