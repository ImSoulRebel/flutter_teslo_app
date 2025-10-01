import 'package:teslo_shop/shared/infrastructure/simple_adapters.dart';

/// Ejemplo simple de uso del patrón adaptador con DIO
class ExampleService {
  final HttpAdapter httpClient;
  final StorageAdapter storage;

  ExampleService()
      : httpClient = DioAdapter(baseUrl: 'https://api.example.com'),
        storage = SharedPreferencesStorageAdapter();

  /// Ejemplo de login
  Future<void> loginExample() async {
    try {
      // Hacer petición de login
      final response = await httpClient.post('/auth/login', {
        'email': 'test@example.com',
        'password': 'password123',
      });

      // Extraer token de la respuesta
      final token = response['token'] as String;

      // Guardar token en almacenamiento local
      await storage.saveToken(token);

      // Configurar token para futuras peticiones
      if (httpClient is DioAdapter) {
        (httpClient as DioAdapter).setAuthToken(token);
      }

      print('Login exitoso');
    } catch (e) {
      print('Error en login: $e');
    }
  }

  /// Ejemplo de obtener datos protegidos
  Future<void> getProtectedDataExample() async {
    try {
      // El token ya está configurado automáticamente
      final response = await httpClient.get('/protected-endpoint');
      print('Datos obtenidos: $response');
    } catch (e) {
      print('Error obteniendo datos: $e');
    }
  }

  /// Ejemplo de logout
  Future<void> logoutExample() async {
    try {
      // Remover token del almacenamiento
      await storage.removeToken();

      // Remover token del cliente HTTP
      if (httpClient is DioAdapter) {
        (httpClient as DioAdapter).removeAuthToken();
      }

      print('Logout exitoso');
    } catch (e) {
      print('Error en logout: $e');
    }
  }
}

/// Factory simple para crear instancias configuradas
class AdapterFactory {
  /// Crea un cliente HTTP configurado para la API de Teslo
  static HttpAdapter createTesloHttpClient() {
    return DioAdapter(baseUrl: 'https://teslo-api.herokuapp.com/api');
  }

  /// Crea un cliente HTTP configurado para otra API
  static HttpAdapter createCustomHttpClient(String baseUrl) {
    return DioAdapter(baseUrl: baseUrl);
  }

  /// Crea un adaptador de almacenamiento
  static StorageAdapter createStorageAdapter() {
    return SharedPreferencesStorageAdapter();
  }
}
