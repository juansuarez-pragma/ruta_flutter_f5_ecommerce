/// Authentication failure types.
enum AuthFailureType {
  /// Invalid credentials (incorrect email/password).
  invalidCredentials,

  /// Email already registered.
  emailAlreadyInUse,

  /// Weak password.
  weakPassword,

  /// Invalid email.
  invalidEmail,

  /// User not found.
  userNotFound,

  /// Connection error.
  connectionError,

  /// Unknown error.
  unknown,
}

