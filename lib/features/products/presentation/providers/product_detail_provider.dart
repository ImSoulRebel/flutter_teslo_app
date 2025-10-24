import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

class ProductDetailState {
  final String id;
  final ProductEntity? product;
  final bool isLoading;
  final bool isSaving;

  ProductDetailState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductDetailState copyWith({
    String? id,
    ProductEntity? product,
    bool? isLoading,
    bool? isSaving,
  }) =>
      ProductDetailState(
        id: id ?? this.id,
        product: product ?? this.product,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}

class ProductDetailNotifier extends Notifier<ProductDetailState> {
  final String id;
  late ProductsUseCases productsUseCases;
  ProductDetailNotifier(this.id);

  @override
  ProductDetailState build() {
    productsUseCases = ref.read(productsUseCasesProvider);
    loadProduct();
    return ProductDetailState(id: id);
  }

  Future<void> loadProduct() async {
    await _tic();
    try {
      state = state.copyWith(isLoading: true);

      final product = await productsUseCases.getProductByIdExecute(state.id);

      state = state.copyWith(isLoading: false, product: product);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> saveProduct(Map<String, dynamic> productLike) async {
    await _tic();
    try {
      state = state.copyWith(isSaving: true);

      final product =
          await productsUseCases.updateOrCreateProductExecute(productLike);

      state = state.copyWith(isSaving: false, product: product);
    } catch (e) {
      state = state.copyWith(isSaving: false);
    }
  }

  Future<void> _tic() async =>
      Future.delayed(const Duration(milliseconds: 500));
}

final productDetailProvider = NotifierProvider.autoDispose
    .family<ProductDetailNotifier, ProductDetailState, String>(
        ProductDetailNotifier.new);
