import 'package:dio/dio.dart';
import '../adapters/http_adapter.dart';

/// Implementación simple del adaptador HTTP usando DIO
class DioAdapter implements HttpAdapter {
  final Dio _dio;

  DioAdapter({String? baseUrl}) : _dio = Dio() {
    if (baseUrl != null) {
      _dio.options.baseUrl = baseUrl;
    }

    // Configuración básica
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  @override
  Future<Map<String, dynamic>> get(String path,
      {Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(
        path,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data,
      {Map<String, String>? headers}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> data,
      {Map<String, String>? headers}) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> delete(String path,
      {Map<String, String>? headers}) async {
    try {
      final response = await _dio.delete(
        path,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Agrega un token de autorización
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remueve el token de autorización
  void removeAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// Maneja la respuesta de DIO
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data as Map<String, dynamic>;
    }
    throw Exception('Error HTTP: ${response.statusCode}');
  }

  /// Maneja los errores de DIO
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return Exception('Tiempo de conexión agotado');
      case DioExceptionType.sendTimeout:
        return Exception('Tiempo de envío agotado');
      case DioExceptionType.receiveTimeout:
        return Exception('Tiempo de respuesta agotado');
      case DioExceptionType.badResponse:
        return Exception('Error del servidor: ${error.response?.statusCode}');
      case DioExceptionType.cancel:
        return Exception('Petición cancelada');
      case DioExceptionType.connectionError:
        return Exception('Error de conexión');
      default:
        return Exception('Error desconocido: ${error.message}');
    }
  }
}
