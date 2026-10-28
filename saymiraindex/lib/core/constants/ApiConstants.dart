// lib/core/api/api_constants.dart
class ApiConstants {
  static const String baseUrl = "https://saymiraindex.com/";

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
}


// lib/core/api/api_exception.dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => "ApiException($statusCode): $message";
}