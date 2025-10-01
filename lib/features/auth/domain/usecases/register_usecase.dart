import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case para registrar un nuevo usuario
class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  /// Ejecuta el caso de uso de registro
  ///
  /// [fullName] - Nombre completo del usuario
  /// [email] - Email del usuario
  /// [password] - Contraseña del usuario
  ///
  /// Returns [UserEntity] si el registro es exitoso
  /// Throws [Exception] si hay algún error
  Future<UserEntity> execute(
      String fullName, String email, String password) async {
    try {
      return await repository.register(fullName, email, password);
    } catch (e) {
      throw Exception('Error durante el registro: ${e.toString()}');
    }
  }
}
