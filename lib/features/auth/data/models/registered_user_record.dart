import 'package:ecommerce/core/error_handling/app_exceptions.dart';

import 'package:ecommerce/features/auth/data/security/password_hasher.dart';
import 'package:ecommerce/features/auth/data/models/user_model.dart';

/// Local persistence record for a registered user.
///
/// This keeps the JSON keys and structure centralized to avoid magic strings
/// scattered across the data source implementation.
class RegisteredUserRecord {
  const RegisteredUserRecord({
    required this.user,
    required this.passwordHash,
  });

  factory RegisteredUserRecord.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final passwordHashJson = json['passwordHash'];

    if (userJson is! Map<String, dynamic>) {
      throw ParseException(
        message: 'Registered user record "user" is not a valid Map',
        failedValue: userJson.toString(),
      );
    }

    if (passwordHashJson is! Map<String, dynamic>) {
      throw ParseException(
        message: 'Registered user record "passwordHash" is not a valid Map',
        failedValue: passwordHashJson.toString(),
      );
    }

    return RegisteredUserRecord(
      user: UserModel.fromJson(userJson),
      passwordHash: PasswordHash.fromJson(passwordHashJson),
    );
  }

  final UserModel user;

  /// Password hash data for verification.
  final PasswordHash passwordHash;

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'passwordHash': passwordHash.toJson(),
  };
}
