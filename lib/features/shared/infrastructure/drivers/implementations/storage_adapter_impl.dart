import 'package:shared_preferences/shared_preferences.dart';
import '../adapters/storage_adapter.dart';

/// Implementación simple del adaptador de almacenamiento usando SharedPreferences
class StorageAdapterImpl implements StorageAdapter {
  static const String _tokenKey = 'auth_token';

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  @override
  Future<bool> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_tokenKey);
  }

  @override
  Future<void> saveKeyValue<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();
    switch (T) {
      case String:
        await prefs.setString(key, value as String);
        break;
      case int:
        await prefs.setInt(key, value as int);
        break;
      case bool:
        await prefs.setBool(key, value as bool);
        break;
      case double:
        await prefs.setDouble(key, value as double);
        break;
      case List<String>:
        await prefs.setStringList(key, value as List<String>);
        break;
      default:
        throw UnsupportedError('Tipo no soportado ${T.runtimeType}');
    }
  }

  @override
  Future<T?> getKeyValue<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    switch (T) {
      case String:
        return prefs.getString(key) as T?;
      case int:
        return prefs.getInt(key) as T?;
      case bool:
        return prefs.getBool(key) as T?;
      case double:
        return prefs.getDouble(key) as T?;
      case List<String>:
        return prefs.getStringList(key) as T?;
      default:
        throw UnsupportedError('Tipo no soportado ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKeyValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
