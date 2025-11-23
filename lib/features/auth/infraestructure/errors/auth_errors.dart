class WrongCredentials implements Exception {
  final String message;
  final int? errorCode;
  WrongCredentials({this.errorCode = 401, this.message = 'Wrong credentials'});
  @override
  String toString() => '''
Wrong credentials Exception:
code: $errorCode
message: $message''';
}

class InvalidToken implements Exception {
  final String message;
  final int errorCode;
  InvalidToken({this.errorCode = 401, this.message = 'Invalid token'});
  @override
  String toString() => '''
Invalid token Exception:
code: $errorCode
message: $message''';
}

class ConnectionTimeout implements Exception {
  final String message;
  final int? errorCode;
  ConnectionTimeout(
      {this.errorCode = 408, this.message = 'Connection timeout exception'});
  @override
  String toString() => '''
Connection timeout Exception:
code: $errorCode
message: $message''';
}

class RegistrationError implements Exception {
  final String message;
  final int? errorCode;
  RegistrationError(
      {this.errorCode = 400, this.message = 'Registration error'});
  @override
  String toString() => '''
Registration error Exception:
code: $errorCode
message: $message''';
}
