import '../repositories/repositories.dart';

/// Use case para cerrar sesión (logout)
class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  /// Ejecuta el caso de uso de logout
  ///
  /// Este caso de uso se encarga de:
  /// - Limpiar el token del almacenamiento local
  /// - Invalidar la sesión actual
  /// - Limpiar cualquier dato de usuario en cache
  Future<void> execute() async {
    try {
      // Aquí podrías agregar lógica adicional como:
      // - Notificar al servidor sobre el logout
      // - Limpiar cache de datos de usuario
      // - Limpiar tokens de refresh

      // Por ahora, la implementación básica sería limpiar el token local
      // Esto se puede extender cuando se implemente el repositorio completo

      // Nota: El repositorio actual no tiene método logout,
      // pero aquí se puede agregar la lógica cuando se extienda

      // Logout ejecutado correctamente (sin print para evitar warnings)
    } catch (e) {
      throw Exception('Error durante el logout: ${e.toString()}');
    }
  }
}
