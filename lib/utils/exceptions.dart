class AuthException implements Exception {
  AuthException(this.code, this.message);

  final String code;
  final String message;
}

class ApiException implements Exception {
  ApiException(this.code, this.message);

  final String code;
  final String message;
}