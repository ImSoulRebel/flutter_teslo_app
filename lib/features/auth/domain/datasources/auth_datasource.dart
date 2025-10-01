import 'package:teslo_shop/features/auth/domain/entities/entities.dart';

abstract class AuthDatasource {
  Future<UserEntity> login(String username, String password);
  Future<UserEntity> register(String username, String password, String email);
  Future<UserEntity> checkAuthStatus(String token);
}
