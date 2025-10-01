import 'package:teslo_shop/features/auth/domain/entities/entities.dart';

abstract class AuthRepository {
  // login
  Future<UserEntity> login(String username, String password);
  // register
  Future<UserEntity> register(String username, String password, String email);
  // check auth status
  Future<UserEntity> checkAuthStatus(String token);
}
