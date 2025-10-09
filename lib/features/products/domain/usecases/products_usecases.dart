import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsUseCases {
  final LoadNextPageUsecase loadNextPage;
  final GetProductByIdUsecase getProductById;
  final UpdateProductUsecase updateProduct;

  ProductsUseCases(
      {required this.loadNextPage,
      required this.getProductById,
      required this.updateProduct});

  factory ProductsUseCases.create(ProductsRepository repository) {
    return ProductsUseCases(
      loadNextPage: LoadNextPageUsecase(repository),
      getProductById: GetProductByIdUsecase(repository),
      updateProduct: UpdateProductUsecase(repository),
    );
  }

  Future<List<ProductEntity>> loadNextPageExecute(
          int limit, int offset) async =>
      await loadNextPage.execute(limit, offset);

  Future<ProductEntity?> getProductByIdExecute(String id) async =>
      await getProductById.execute(id);

  Future<ProductEntity> updateProductExecute(
          Map<String, dynamic> productLike) async =>
      await updateProduct.execute(productLike);
}
