class AuthException implements Exception {
  const AuthException(this.code, this.message);

  final String code;
  final String message;
}