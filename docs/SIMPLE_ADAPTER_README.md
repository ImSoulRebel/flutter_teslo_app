# Patrón Adaptador Simple para DIO

Este es un patrón adaptador simplificado que encapsula DIO y SharedPreferences de manera sencilla y práctica.

## ¿Por qué usar este patrón?

1. **🔄 Flexibilidad**: Puedes cambiar fácilmente de DIO a otro cliente HTTP sin afectar tu código de negocio
2. **🧪 Testeable**: Fácil de hacer mock para pruebas unitarias
3. **🏗️ Mantenible**: Cambios en la implementación HTTP no afectan tu lógica de negocio
4. **📝 Simple**: Menos código que implementaciones complejas

## Estructura Simple

```
shared/infrastructure/
├── adapters/
│   ├── http_adapter.dart           # Interfaz simple para HTTP
│   └── storage_adapter.dart        # Interfaz simple para almacenamiento
├── implementations/
│   ├── dio_adapter.dart            # Implementación con DIO
│   └── shared_preferences_storage_adapter.dart # Implementación con SharedPreferences
├── examples/
│   └── simple_adapter_examples.dart # Ejemplos de uso
└── simple_adapters.dart            # Exportaciones
```

## Interfaces Simples

### HttpAdapter

```dart
abstract class HttpAdapter {
  Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers});
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data, {Map<String, String>? headers});
  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> data, {Map<String, String>? headers});
  Future<Map<String, dynamic>> delete(String path, {Map<String, String>? headers});
}
```

### StorageAdapter

```dart
abstract class StorageAdapter {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> removeToken();
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> remove(String key);
}
```

## Uso Básico

### 1. Configuración Simple

```dart
// Crear adaptadores
final httpClient = DioAdapter(baseUrl: 'https://api.example.com');
final storage = SharedPreferencesStorageAdapter();
```

### 2. Login con Tokens

```dart
// Login
final response = await httpClient.post('/auth/login', {
  'email': email,
  'password': password,
});

final token = response['token'];
await storage.saveToken(token);
httpClient.setAuthToken(token); // Configura para futuras peticiones
```

### 3. Peticiones Autenticadas

```dart
// Las peticiones ahora incluyen automáticamente el token
final userData = await httpClient.get('/user/profile');
```

### 4. Logout

```dart
await storage.removeToken();
httpClient.removeAuthToken();
```

## En tu AuthDatasourceImpl

```dart
class AuthDatasourceImpl extends AuthDatasource {
  final HttpAdapter httpClient;
  final StorageAdapter storage;

  AuthDatasourceImpl({
    HttpAdapter? httpClient,
    StorageAdapter? storage,
  })  : httpClient = httpClient ?? DioAdapter(baseUrl: 'https://teslo-api.herokuapp.com/api'),
        storage = storage ?? SharedPreferencesStorageAdapter();

  @override
  Future<UserEntity> login(String email, String password) async {
    final response = await httpClient.post('/auth/login', {
      'email': email,
      'password': password,
    });

    final userEntity = UserEntity.fromJson(response);

    // Guardar y configurar token automáticamente
    await storage.saveToken(userEntity.token);
    if (httpClient is DioAdapter) {
      (httpClient as DioAdapter).setAuthToken(userEntity.token);
    }

    return userEntity;
  }
}
```

## Ventajas de esta Implementación Simple

### ✅ **Menos Código**

- Solo las interfaces necesarias
- Implementaciones directas sin capas extra
- Métodos específicos para tokens

### ✅ **Fácil de Entender**

- Interfaces claras y simples
- Métodos con nombres descriptivos
- Lógica directa sin abstracciones complejas

### ✅ **Configuración Automática**

- Token se configura automáticamente después del login
- Headers se manejan internamente
- Timeouts preconfigurados

### ✅ **Manejo de Errores Simplificado**

```dart
try {
  final data = await httpClient.get('/endpoint');
} catch (e) {
  // Errores ya convertidos a excepciones legibles
  print('Error: $e'); // "Tiempo de conexión agotado", etc.
}
```

## Para Testing

### Mock Simple

```dart
class MockHttpAdapter implements HttpAdapter {
  @override
  Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers}) async {
    return {'mock': 'data'};
  }

  @override
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data, {Map<String, String>? headers}) async {
    return {'token': 'mock-token', 'user': 'mock-user'};
  }

  // ... otros métodos
}

class MockStorageAdapter implements StorageAdapter {
  String? _token;

  @override
  Future<void> saveToken(String token) async => _token = token;

  @override
  Future<String?> getToken() async => _token;

  // ... otros métodos
}
```

### Test Example

```dart
void main() {
  test('should login successfully', () async {
    final authDataSource = AuthDatasourceImpl(
      httpClient: MockHttpAdapter(),
      storage: MockStorageAdapter(),
    );

    final user = await authDataSource.login('test@test.com', 'password');

    expect(user.email, 'test@test.com');
  });
}
```

## Factory Pattern (Opcional)

```dart
class AdapterFactory {
  static HttpAdapter createTesloHttpClient() {
    return DioAdapter(baseUrl: 'https://teslo-api.herokuapp.com/api');
  }

  static StorageAdapter createStorageAdapter() {
    return SharedPreferencesStorageAdapter();
  }
}
```

## Comparación: Simple vs Complejo

| Aspecto                  | Patrón Simple    | Patrón Complejo    |
| ------------------------ | ---------------- | ------------------ |
| **Líneas de código**     | ~200 líneas      | ~800+ líneas       |
| **Interfaces**           | 2 simples        | 5+ complejas       |
| **Configuración**        | Automática       | Manual             |
| **Curva de aprendizaje** | Baja             | Alta               |
| **Flexibilidad**         | Media            | Alta               |
| **Casos de uso**         | 90% aplicaciones | Sistemas complejos |

## Cuándo Usar Cada Uno

### 🟢 **Usa el Patrón Simple cuando:**

- Tu app tiene necesidades HTTP básicas
- Quieres empezar rápido
- Tu equipo prefiere simplicidad
- No necesitas interceptors complejos

### 🟡 **Usa el Patrón Complejo cuando:**

- Necesitas interceptors avanzados
- Manejas múltiples tipos de respuesta
- Requieres logging detallado
- Tienes sistemas muy complejos

Este patrón simple cubre el 90% de casos de uso mientras mantiene la flexibilidad y testabilidad del patrón adaptador.
