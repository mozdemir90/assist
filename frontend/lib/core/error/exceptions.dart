class CustomAppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  CustomAppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException: $message \${code != null ? "($code)" : ""}';
}

class NetworkException extends CustomAppException {
  NetworkException(super.message, {super.code, super.details});
}

class AuthException extends CustomAppException {
  AuthException(super.message, {super.code, super.details});
}

class DatabaseException extends CustomAppException {
  DatabaseException(super.message, {super.code, super.details});
}
