import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

import 'products_usecases_provider.dart';

class ProductsState {
  final bool isLoading;
  final bool isLastPage;
  final int limit;
  final int offset;
  final List<ProductEntity> products;

  ProductsState({
    this.isLoading = false,
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLoading,
    List<ProductEntity>? products,
    bool? isLastPage,
    int? limit,
    int? offset,
  }) {
    return ProductsState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      isLastPage: isLastPage ?? this.isLastPage,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
    );
  }
}

class ProductsNotifier extends Notifier<ProductsState> {
  late ProductsUseCases productsUseCases;

  @override
  ProductsState build() {
    productsUseCases = ref.read(productsUseCasesProvider);
    loadNextPage();
    return ProductsState();
  }

  Future<void> loadNextPage() async {
    await _tic();
    try {
      if (state.isLoading || state.isLastPage) return;

      state = state.copyWith(isLoading: true);

      // Obtiene la siguiente página de productos desde el caso de uso
      final products =
          await productsUseCases.loadNextPageExecute(state.limit, state.offset);

      // Si no hay productos, marca como última página
      if (products.isEmpty) {
        state = state.copyWith(isLoading: false, isLastPage: true);
        return;
      }

      // Determina si es la última página comparando con el límite
      final isLastPage = products.length < state.limit;

      // Actualiza el estado con los nuevos productos y parámetros
      state = state.copyWith(
        isLoading: false,
        isLastPage: isLastPage,
        products: [
          ...state.products,
          ...products
        ], // Combina productos existentes con nuevos
        offset: state.offset +
            products.length, // Actualiza el offset para la siguiente carga
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    // Evita cargar si ya está cargando o si llegó a la última página
  }
  Future<void> _tic() => Future.delayed(const Duration(milliseconds: 500));

}

final productsProvider =
    NotifierProvider<ProductsNotifier, ProductsState>(ProductsNotifier.new);
