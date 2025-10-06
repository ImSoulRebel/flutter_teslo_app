import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

import 'products_repository_provider.dart';

final productsUseCasesProvider = Provider<ProductsUseCases>((ref) {
  final repository = ref.watch(productsRepositoryProvider);
  final useCases = ProductsUseCases.create(repository);
  return useCases;
});
