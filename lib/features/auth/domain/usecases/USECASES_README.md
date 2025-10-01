# AuthUseCases - Casos de Uso de Autenticación

Los **AuthUseCases** implementan la lógica de negocio de autenticación siguiendo los principios de Clean Architecture. Cada caso de uso encapsula una operación específica y contiene las validaciones de negocio correspondientes.

## 🏗️ Estructura

```
auth/domain/usecases/
├── login_usecase.dart              # Caso de uso para login
├── register_usecase.dart           # Caso de uso para registro
├── check_auth_status_usecase.dart  # Caso de uso para verificar autenticación
├── logout_usecase.dart             # Caso de uso para logout
├── auth_usecases.dart              # Facade que agrupa todos los casos de uso
└── usecases.dart                   # Archivo de exportación
```

## 📋 Casos de Uso Disponibles

### 1. 🔑 LoginUseCase

**Propósito**: Autenticar un usuario existente

**Validaciones**:

- Email requerido y formato válido
- Contraseña requerida (mínimo 6 caracteres)

**Uso**:

```dart
final loginUseCase = LoginUseCase(repository);
final user = await loginUseCase.execute('user@example.com', 'password123');
```

### 2. 📝 RegisterUseCase

**Propósito**: Registrar un nuevo usuario

**Validaciones**:

- Nombre completo requerido (mínimo 2 caracteres)
- Email requerido y formato válido
- Contraseña requerida (mínimo 6 caracteres)

**Uso**:

```dart
final registerUseCase = RegisterUseCase(repository);
final user = await registerUseCase.execute('Juan Pérez', 'juan@example.com', 'password123');
```

### 3. ✅ CheckAuthStatusUseCase

**Propósito**: Verificar si el token de autenticación es válido

**Validaciones**:

- Token requerido
- Formato básico de JWT válido

**Uso**:

```dart
final checkAuthUseCase = CheckAuthStatusUseCase(repository);
final user = await checkAuthUseCase.execute('jwt-token-here');
```

### 4. 🚪 LogoutUseCase

**Propósito**: Cerrar sesión del usuario

**Funcionalidad**:

- Limpia tokens del almacenamiento local
- Invalida la sesión actual
- Prepara para futuras extensiones (notificar servidor, etc.)

**Uso**:

```dart
final logoutUseCase = LogoutUseCase(repository);
await logoutUseCase.execute();
```

## 🎯 AuthUseCases Facade

La clase `AuthUseCases` actúa como un **facade** que agrupa todos los casos de uso:

```dart
// Crear instancia
final authUseCases = AuthUseCases.create(repository);

// Usar métodos de conveniencia
final user = await authUseCases.login('email@example.com', 'password');
final newUser = await authUseCases.register('Juan', 'juan@example.com', 'password');
final currentUser = await authUseCases.checkAuthStatus('token');
await authUseCases.logout();
```

## 🔧 Integración con Providers

### AuthUseCasesProvider

```dart
final authUseCasesProvider = Provider<AuthUseCases>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthUseCases.create(repository);
});
```

### Uso en AuthNotifier

```dart
class AuthNotifier extends Notifier<AuthState> {
  late AuthUseCases authUseCases;

  @override
  AuthState build() {
    authUseCases = ref.read(authUseCasesProvider);
    return AuthState();
  }

  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(status: AuthStatus.checking);
      final user = await authUseCases.login(email, password);
      state = state.copyWith(user: user, status: AuthStatus.authenticated);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.notAuthenticated,
        errorMessage: e.toString(),
      );
    }
  }
}
```

## 📱 Uso en Widgets

```dart
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        ref.read(authProvider.notifier).login(email, password);
      },
      child: Text('Iniciar Sesión'),
    );
  }
}
```

## ✅ Ventajas de los Use Cases

### 🔒 **Encapsulación de Lógica de Negocio**

- Cada caso de uso tiene una responsabilidad específica
- Validaciones centralizadas y reutilizables
- Lógica de negocio independiente de la UI

### 🧪 **Testabilidad**

```dart
void main() {
  test('should login successfully with valid credentials', () async {
    // Arrange
    final mockRepository = MockAuthRepository();
    final loginUseCase = LoginUseCase(mockRepository);

    // Act
    final result = await loginUseCase.execute('test@test.com', 'password123');

    // Assert
    expect(result.email, 'test@test.com');
  });

  test('should throw exception for invalid email', () async {
    // Arrange
    final loginUseCase = LoginUseCase(mockRepository);

    // Act & Assert
    expect(
      () => loginUseCase.execute('invalid-email', 'password'),
      throwsA(isA<Exception>()),
    );
  });
}
```

### 🔄 **Reutilización**

- Los mismos use cases pueden usarse en diferentes partes de la app
- Fácil integración con diferentes providers
- Lógica consistente en toda la aplicación

### 🎯 **Separación de Responsabilidades**

- **Use Cases**: Lógica de negocio y validaciones
- **Repository**: Acceso a datos
- **Providers**: Gestión de estado
- **Widgets**: Presentación

## 🚀 Extensiones Futuras

### Casos de Uso Adicionales

```dart
// Futuras implementaciones
class ChangePasswordUseCase { ... }
class RefreshTokenUseCase { ... }
class ForgotPasswordUseCase { ... }
class UpdateProfileUseCase { ... }
```

### Validaciones Avanzadas

```dart
class ValidationRules {
  static bool isStrongPassword(String password) { ... }
  static bool isValidPhoneNumber(String phone) { ... }
  static bool isValidName(String name) { ... }
}
```

## 📊 Flujo de Datos

```
Widget → Provider → UseCase → Repository → DataSource → API/Storage
  ↓         ↓         ↓          ↓           ↓
State  ← Notifier ← Response ← Entity   ← Adapter ← External Service
```

Este patrón garantiza que la lógica de negocio esté bien organizada, sea testeable y mantenga la separación de responsabilidades en tu aplicación Flutter.
