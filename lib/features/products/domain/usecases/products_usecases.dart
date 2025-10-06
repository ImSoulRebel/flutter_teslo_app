import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsUseCases {
  final LoadNextPageUsecase loadNextPage;
  ProductsUseCases({required this.loadNextPage});

  factory ProductsUseCases.create(ProductsRepository repository) {
    return ProductsUseCases(loadNextPage: LoadNextPageUsecase(repository));
  }

  Future<List<ProductEntity>> loadNextPageExecute(
          int limit, int offset) async =>
      await loadNextPage.execute(limit, offset);
}
