import 'package:ecommerce/core/error_handling/app_exceptions.dart';

import 'package:ecommerce/features/auth/data/models/user_model.dart';

/// Local persistence record for a registered user.
///
/// This keeps the JSON keys and structure centralized to avoid magic strings
/// scattered across the data source implementation.
class RegisteredUserRecord {
  const RegisteredUserRecord({
    required this.user,
    required this.passwordEncoded,
  });

  factory RegisteredUserRecord.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final passwordEncoded = json['password'];

    if (userJson is! Map<String, dynamic>) {
      throw ParseException(
        message: 'Registered user record "user" is not a valid Map',
        failedValue: userJson.toString(),
      );
    }

    if (passwordEncoded is! String) {
      throw ParseException(
        message: 'Registered user record "password" is not a valid String',
        failedValue: passwordEncoded.toString(),
      );
    }

    return RegisteredUserRecord(
      user: UserModel.fromJson(userJson),
      passwordEncoded: passwordEncoded,
    );
  }

  final UserModel user;

  /// Encoded password as stored in SharedPreferences.
  final String passwordEncoded;

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'password': passwordEncoded,
  };
}

