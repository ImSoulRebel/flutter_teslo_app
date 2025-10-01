import 'package:teslo_shop/features/auth/domain/domain.dart';

class AuthDatasourceImpl extends AuthDatasource {



  @override
  Future<UserEntity> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> login(String username, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<UserEntity> register(String username, String password, String email) {
    // TODO: implement register
    throw UnimplementedError();
  }
}


// patrón adaptador para envolver DIO, http, shared_preferences, etc
// y que no se vea en el dominio




