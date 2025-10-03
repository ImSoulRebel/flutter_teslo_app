/// Adaptador simple para almacenamiento local
abstract class StorageAdapter {
  /// Métodos específicos para el token de autenticación
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<bool> removeToken();

  /// Métodos genéricos para almacenamiento de clave-valor
  Future<void> saveKeyValue<T>(String key, T value);
  Future<T?> getKeyValue<T>(String key);
  Future<bool> removeKeyValue(String key);
}
