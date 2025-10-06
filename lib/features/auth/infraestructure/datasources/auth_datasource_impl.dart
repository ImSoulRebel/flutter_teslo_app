import 'package:flutter/foundation.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infraestructure/mappers/mappers.dart';
import 'package:teslo_shop/shared/infrastructure/simple_adapters.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final httpAdapter = DioAdapter(baseUrl: Environment.apiUrl);

  @override
  Future<UserEntity> checkAuthStatus(String token) async {
    try {
      final response = await httpAdapter.get('/auth/check-status', headers: {
        'Authorization': 'Bearer $token',
      });

      final user = UserMapper.fromJsonToEntity(response);
      return user;
    } on WrongCredentials catch (e) {
      debugPrint('AuthDatasourceImpl checkAuthStatus error: ${e.toString()}');
      // Si ya es una WrongCredentials (del DioAdapter), la re-lanzamos
      rethrow;
    } on ConnectionTimeout catch (e) {
      debugPrint('AuthDatasourceImpl checkAuthStatus error: ${e.toString()}');
      rethrow;
    } catch (e) {
      debugPrint('AuthDatasourceImpl checkAuthStatus error: ${e.toString()}');
      // Para otros errores, los envolvemos en WrongCredentials
      throw WrongCredentials(message: 'Error de autenticación');
    }
  }

  @override
  Future<UserEntity> login(String username, String password) async {
    try {
      final response = await httpAdapter.post('/auth/login', {
        'email': username,
        'password': password,
      });

      final user = UserMapper.fromJsonToEntity(response);
      return user;
    } on WrongCredentials catch (e) {
      debugPrint('AuthDatasourceImpl login error: ${e.toString()}');
      // Si ya es una WrongCredentials (del DioAdapter), la re-lanzamos
      rethrow;
    } on ConnectionTimeout catch (e) {
      debugPrint('AuthDatasourceImpl login error: ${e.toString()}');
      rethrow;
    } catch (e) {
      debugPrint('AuthDatasourceImpl login error: ${e.toString()}');
      // Para otros errores, los envolvemos en WrongCredentials
      throw WrongCredentials(message: 'Error de autenticación');
    }
  }

  @override
  Future<UserEntity> register(String username, String password, String email) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
