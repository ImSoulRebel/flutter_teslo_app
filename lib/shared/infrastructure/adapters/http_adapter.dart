/// Adaptador simple para cliente HTTP
abstract class HttpAdapter {
  Future<Map<String, dynamic>> get(String path, {Map<String, String>? headers});
  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data,
      {Map<String, String>? headers});
  Future<Map<String, dynamic>> put(String path, Map<String, dynamic> data,
      {Map<String, String>? headers});
  Future<Map<String, dynamic>> delete(String path,
      {Map<String, String>? headers});
}
