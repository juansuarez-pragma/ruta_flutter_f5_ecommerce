import 'package:ecommerce/features/auth/domain/entities/user.dart';

/// Modelo de datos para User con serialización JSON.
///
/// Extiende la entidad User y agrega funcionalidad para
/// conversión desde/hacia JSON para persistencia.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.firstName,
    required super.lastName,
    super.token,
  });

  /// Crea un UserModel desde una entidad User.
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

  /// Crea un UserModel desde un mapa JSON.
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

  /// Convierte el UserModel a un mapa JSON.
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

  /// Convierte a entidad User del dominio.
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

  /// Crea una copia con token actualizado.
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
