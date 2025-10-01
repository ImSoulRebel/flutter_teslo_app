import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case para iniciar sesión
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Ejecuta el caso de uso de login
  ///
  /// [email] - Email del usuario
  /// [password] - Contraseña del usuario
  ///
  /// Returns [UserEntity] si el login es exitoso
  /// Throws [Exception] si hay algún error
  Future<UserEntity> execute(String email, String password) async {
    try {
      return await repository.login(email, password);
    } catch (e) {
      throw Exception('Error durante el login: ${e.toString()}');
    }
  }
}
