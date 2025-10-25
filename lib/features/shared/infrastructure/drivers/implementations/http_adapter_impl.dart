import 'package:dio/dio.dart';
import 'package:teslo_shop/features/auth/infraestructure/errors/errors.dart';
import '../adapters/http_adapter.dart';

/// Implementación simple del adaptador HTTP usando DIO
class HttpAdapterImpl implements HttpAdapter {
  final Dio _dio;

  HttpAdapterImpl({String? baseUrl}) : _dio = Dio() {
    if (baseUrl != null) {
      _dio.options.baseUrl = baseUrl;
    }

    // Configuración básica
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  @override
  Future<dynamic> get(String path, {Map<String, String>? headers}) async {
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

  @override
  Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> data,
      {Map<String, String>? headers}) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
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
  dynamic _handleResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      // Retornamos directamente la data, puede ser Map, List o cualquier tipo
      return response.data;
    }
    throw Exception('Error HTTP: ${response.statusCode}');
  }

  /// Maneja los errores de DIO
  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ConnectionTimeout(
            errorCode: error.response?.statusCode,
            message: 'Tiempo de conexión agotado, por favor intente más tarde');
      case DioExceptionType.sendTimeout:
        return Exception('Tiempo de envío agotado');
      case DioExceptionType.receiveTimeout:
        return Exception('Tiempo de respuesta agotado');
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
      case DioExceptionType.cancel:
        return Exception('Petición cancelada');
      case DioExceptionType.connectionError:
        return Exception('Error de conexión');
      default:
        return Exception('Error desconocido: ${error.message}');
    }
  }

  /// Maneja específicamente las respuestas de error del servidor
  Exception _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    // Si la respuesta es un Map (JSON), extraemos la información
    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'] as String?;

      // Manejar errores 401 (Unauthorized) como credenciales incorrectas
      if (statusCode == 401) {
        return WrongCredentials(
          errorCode: statusCode,
          message: message ?? 'Credenciales incorrectas',
        );
      }

      // Para otros códigos de estado, usar el mensaje del servidor si está disponible
      return Exception(
          message ?? error.response?.statusMessage ?? 'Error del servidor');
    }

    // Si no es un JSON válido, usar el mensaje por defecto
    return Exception(error.response?.statusMessage ?? 'Error del servidor');
  }
}
