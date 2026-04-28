class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalException;

  ApiException({
    required this.message,
    this.statusCode,
    this.originalException,
  });

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException({String message = 'Ağ bağlantısı hatası'})
      : super(message: message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({String message = 'Yetkisiz erişim'})
      : super(message: message, statusCode: 401);
}

class NotFoundException extends ApiException {
  NotFoundException({String message = 'Kaynak bulunamadı'})
      : super(message: message, statusCode: 404);
}

class ServerException extends ApiException {
  ServerException({String message = 'Sunucu hatası'})
      : super(message: message, statusCode: 500);
}

class ValidationException extends ApiException {
  ValidationException({String message = 'Doğrulama hatası'})
      : super(message: message, statusCode: 422);
}
