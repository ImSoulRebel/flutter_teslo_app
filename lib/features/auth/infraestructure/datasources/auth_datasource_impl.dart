import 'package:flutter/foundation.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/auth/infraestructure/mappers/mappers.dart';
import 'package:teslo_shop/shared/infrastructure/simple_adapters.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final httpAdapter = DioAdapter(baseUrl: Environment.apiUrl);

  @override
  Future<UserEntity> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> login(String username, String password) async {
    try {
      final response = await httpAdapter.post('/auth/login', {
        'email': username,
        'password': password,
      });

      final user = UserMapper.userEntityFromMap(response);
      return user;
    } catch (e) {
      debugPrint('AuthDatasourceImpl error: ${e.toString()}');
      // Si ya es una WrongCredentials (del DioAdapter), la re-lanzamos
      if (e is WrongCredentials) rethrow;

      // Para otros tipos de errores, los envolvemos
      throw WrongCredentials(
          message: 'Error en autenticación: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> register(String username, String password, String email) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
