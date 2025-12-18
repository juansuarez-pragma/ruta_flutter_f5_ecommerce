/// Auth data source specific exceptions.
class AuthLocalException implements Exception {
  const AuthLocalException(this.message);

  final String message;

  @override
  String toString() => 'AuthLocalException: $message';
}
