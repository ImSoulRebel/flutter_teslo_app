import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infraestructure/insfraestructure.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final productsRepository = ProductsRepositoryImpl(
    datasource: ProductsDatasourceImpl(
        accesToken: ref.watch(authProvider).user?.token ?? ''),
  );

  return productsRepository;
});
