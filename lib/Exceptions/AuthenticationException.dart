class AuthenticationException implements Exception {
  String message = "authentication failed";
  int code = 0;
  AuthenticationException(this.code);
}
