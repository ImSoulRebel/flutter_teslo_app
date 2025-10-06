import 'package:teslo_shop/features/products/domain/entities/entities.dart';

abstract class ProductsRepository {
  Future<List<ProductEntity>> getProductsByPage(int limit, int offset);
  Future<ProductEntity> getProductById(String id);
  Future<List<ProductEntity>> getProductsByTerm(String term);
  Future<ProductEntity> createUpdateProduct(Map<String, dynamic> productLike);
  // Future<ProductEntity> createProduct(ProductEntity product);
  // Future<ProductEntity> updateProduct(ProductEntity product);
  Future<void> deleteProduct(String id);
}
