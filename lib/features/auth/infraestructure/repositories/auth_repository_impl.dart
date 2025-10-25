import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/datasources/datasources.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(AuthDatasource? datasource)
      : datasource = datasource ?? AuthDatasourceImpl();

  @override
  Future<UserEntity> checkAuthStatus(String token) =>
      datasource.checkAuthStatus(token);

  @override
  Future<UserEntity> login(String username, String password) =>
      datasource.login(username, password);

  @override
  Future<UserEntity> register(String username, String password, String email) =>
      datasource.register(username, password, email);
}
