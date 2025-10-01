import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/repositories/auth_repository_impl.dart';
import 'package:teslo_shop/features/auth/infraestructure/datasources/auth_datasource_impl.dart';

/// Provider para el repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Crear el datasource con los adaptadores
  final datasource = AuthDatasourceImpl();
  return AuthRepositoryImpl(datasource);
});

/// Provider para los casos de uso de autenticación
final authUseCasesProvider = Provider<AuthUseCases>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthUseCases.create(repository);
});
