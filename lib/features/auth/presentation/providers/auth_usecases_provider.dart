import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';

import 'auth_repository_provider.dart';

/// Provider para los casos de uso de autenticación
final authUseCasesProvider = Provider<AuthUseCases>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthUseCases.create(repository);
});
