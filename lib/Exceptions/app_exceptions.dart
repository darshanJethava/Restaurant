class AppException implements Exception {
  final String message;
  final String? prefix;
  final dynamic originalException;

  AppException({required this.message, this.prefix, this.originalException});

  @override
  String toString() {
    return '$prefix$message';
  }
}

class ApiException extends AppException {
  ApiException({required String message, dynamic originalException})
    : super(
        message: message,
        prefix: 'API Error: ',
        originalException: originalException,
      );
}

class ParseException extends AppException {
  ParseException({required String message, dynamic originalException})
    : super(
        message: message,
        prefix: 'Parse Error: ',
        originalException: originalException,
      );
}

class NetworkException extends AppException {
  NetworkException({required String message, dynamic originalException})
    : super(
        message: message,
        prefix: 'Network Error: ',
        originalException: originalException,
      );
}

class RepositoryException extends AppException {
  RepositoryException({required String message, dynamic originalException})
    : super(
        message: message,
        prefix: 'Repository Error: ',
        originalException: originalException,
      );
}
