import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/infraestructure.dart';

/// Provider para el repositorio de autenticación
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // Crear el datasource con los adaptadores
  final datasource = AuthDatasourceImpl();
  return AuthRepositoryImpl(datasource);
});
