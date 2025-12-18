/// Excepciones específicas del DataSource de autenticación.
class AuthLocalException implements Exception {
  const AuthLocalException(this.message);

  final String message;

  @override
  String toString() => 'AuthLocalException: $message';
}

