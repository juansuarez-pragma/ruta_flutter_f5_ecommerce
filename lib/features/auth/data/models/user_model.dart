import 'package:ecommerce/features/auth/domain/entities/user.dart';

/// User data model with JSON serialization.
///
/// Extends the User entity and adds conversion to/from JSON for persistence.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.firstName,
    required super.lastName,
    super.token,
  });

  /// Creates a UserModel from a domain User entity.
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      firstName: user.firstName,
      lastName: user.lastName,
      token: user.token,
    );
  }

  /// Creates a UserModel from a JSON map.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      token: json['token'] as String?,
    );
  }

  /// Converts the UserModel to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'token': token,
    };
  }

  /// Converts to a domain User entity.
  User toEntity() {
    return User(
      id: id,
      email: email,
      username: username,
      firstName: firstName,
      lastName: lastName,
      token: token,
    );
  }

  /// Creates a copy with an updated token.
  UserModel copyWithToken(String? newToken) {
    return UserModel(
      id: id,
      email: email,
      username: username,
      firstName: firstName,
      lastName: lastName,
      token: newToken,
    );
  }
}
