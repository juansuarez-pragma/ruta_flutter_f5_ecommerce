import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/core/error_handling/app_exceptions.dart';
import 'package:ecommerce/core/error_handling/app_logger.dart';
import 'package:ecommerce/core/error_handling/error_handling_utils.dart';
import 'package:ecommerce/core/utils/clock.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_storage_keys.dart';
import 'package:ecommerce/features/auth/data/errors/auth_local_exception.dart';
import 'package:ecommerce/features/auth/data/models/registered_user_record.dart';
import 'package:ecommerce/features/auth/data/models/user_model.dart';

/// [AuthLocalDataSource] implementation using SharedPreferences.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required AppLogger logger,
    required Clock clock,
  }) : _logger = logger,
       _clock = clock;

  final SharedPreferences sharedPreferences;
  final AppLogger _logger;
  final Clock _clock;

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

    final registeredUsers = await _getRegisteredUsers();
    final nextUserId = _nextUserId(registeredUsers);
    final token = _generateToken(email);

    final newUser = UserModel(
      id: nextUserId,
      email: email,
      username: username,
      firstName: firstName,
      lastName: lastName,
      token: token,
    );

    final registeredUserRecords = await _getRegisteredUserRecords();
    registeredUserRecords.add(
      RegisteredUserRecord(
        user: newUser,
        passwordEncoded: _encodePasswordForStorage(password),
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
    final registeredUserRecords = await _getRegisteredUserRecords();

    for (final record in registeredUserRecords) {
      if (record.user.email == email &&
          record.passwordEncoded == _encodePasswordForStorage(password)) {
        final user = record.user;
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
    final registeredUserRecords = await _getRegisteredUserRecords();
    return registeredUserRecords.map((record) => record.user).toList();
  }

  Future<List<RegisteredUserRecord>> _getRegisteredUserRecords() async {
    final usersJson = sharedPreferences.getString(AuthStorageKeys.registeredUsers);
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
    await sharedPreferences.setString(AuthStorageKeys.registeredUsers, usersJson);
  }

  int _nextUserId(List<UserModel> existingUsers) {
    if (existingUsers.isEmpty) return 1;

    final maxExistingUserId = existingUsers
        .map((user) => user.id)
        .fold<int>(0, (maxSoFar, id) => id > maxSoFar ? id : maxSoFar);

    return maxExistingUserId + 1;
  }

  String _generateToken(String email) {
    final timestamp = _clock.now().millisecondsSinceEpoch;
    return base64.encode(utf8.encode('$email:$timestamp'));
  }

  String _encodePasswordForStorage(String password) {
    return base64.encode(utf8.encode(password));
  }
}
