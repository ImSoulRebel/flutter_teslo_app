import 'package:flutter/foundation.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
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
      debugPrint(e.toString());
      throw Exception('Error en login: $e');
    }
  }

  @override
  Future<UserEntity> register(String username, String password, String email) {
    // TODO: implement register
    throw UnimplementedError();
  }
}


// patrón adaptador para envolver DIO, http, shared_preferences, etc
// y que no se vea en el dominio




