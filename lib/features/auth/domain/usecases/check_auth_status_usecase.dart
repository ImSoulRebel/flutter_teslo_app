import '../entities/entities.dart';
import '../repositories/repositories.dart';

/// Use case para verificar el estado de autenticación
class CheckAuthStatusUseCase {
  final AuthRepository repository;

  CheckAuthStatusUseCase(this.repository);

  /// Ejecuta el caso de uso de verificación de estado de autenticación
  ///
  /// [token] - Token de autenticación a verificar
  ///
  /// Returns [UserEntity] si el token es válido
  /// Throws [Exception] si el token es inválido o hay algún error
  Future<UserEntity> execute(String token) async {
    // Validaciones básicas
    if (token.isEmpty) {
      throw Exception('El token es requerido');
    }

    // Validación básica del formato del token (JWT básico)
    if (!_isValidTokenFormat(token)) {
      throw Exception('El formato del token no es válido');
    }

    try {
      return await repository.checkAuthStatus(token);
    } catch (e) {
      throw Exception(
          'Error verificando el estado de autenticación: ${e.toString()}');
    }
  }

  /// Valida el formato básico del token JWT
  bool _isValidTokenFormat(String token) {
    // Un JWT básico tiene 3 partes separadas por puntos
    final parts = token.split('.');
    return parts.length == 3 && token.length > 10;
  }
}
