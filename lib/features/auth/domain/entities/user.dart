import 'package:equatable/equatable.dart';

/// Domain user entity.
///
/// Represents an authenticated user in the system.
class User extends Equatable {

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.token,
  });

  /// Unique user identifier.
  final int id;

  /// User email.
  final String email;

  /// Username.
  final String username;

  /// User first name.
  final String firstName;

  /// User last name.
  final String lastName;

  /// Authentication token (optional, used for active sessions).
  final String? token;

  /// Formatted full name.
  String get fullName => '$firstName $lastName';

  /// Whether the user has a valid token.
  bool get isAuthenticated => token != null && token!.isNotEmpty;

  /// Creates a copy with optional changes.
  User copyWith({
    int? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? token,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [id, email, username, firstName, lastName, token];
}
