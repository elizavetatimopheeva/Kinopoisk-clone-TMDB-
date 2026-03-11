enum ApiCLientExceptionType { network, auth, other, sessionExpired }

class ApiCLientException implements Exception {
  final ApiCLientExceptionType type;

  ApiCLientException(this.type);
}
