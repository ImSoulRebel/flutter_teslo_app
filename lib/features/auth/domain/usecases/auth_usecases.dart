import '../entities/entities.dart';
import '../repositories/repositories.dart';
import 'login_usecase.dart';
import 'register_usecase.dart';
import 'check_auth_status_usecase.dart';
import 'logout_usecase.dart';

/// Clase que agrupa todos los casos de uso de autenticación
///
/// Esta clase actúa como un facade que proporciona acceso
/// a todos los use cases relacionados con autenticación
class AuthUseCases {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;
  final LogoutUseCase logoutUseCase;

  AuthUseCases({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.checkAuthStatusUseCase,
    required this.logoutUseCase,
  });

  /// Factory constructor que crea todos los use cases con el mismo repositorio
  factory AuthUseCases.create(AuthRepository repository) {
    return AuthUseCases(
      loginUseCase: LoginUseCase(repository),
      registerUseCase: RegisterUseCase(repository),
      checkAuthStatusUseCase: CheckAuthStatusUseCase(repository),
      logoutUseCase: LogoutUseCase(repository),
    );
  }

  /// Método de conveniencia para login
  Future<UserEntity> login(String email, String password) {
    return loginUseCase.execute(email, password);
  }

  /// Método de conveniencia para registro
  Future<UserEntity> register(String fullName, String email, String password) {
    return registerUseCase.execute(fullName, email, password);
  }

  /// Método de conveniencia para verificar estado de autenticación
  Future<UserEntity> checkAuthStatus(String token) {
    return checkAuthStatusUseCase.execute(token);
  }

  /// Método de conveniencia para logout
  Future<void> logout() {
    return logoutUseCase.execute();
  }
}
