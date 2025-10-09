import 'package:flutter/foundation.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class UpdateProductUsecase {
  final ProductsRepository repository;

  UpdateProductUsecase(this.repository);

  Future<ProductEntity> execute(Map<String, dynamic> productLike) async {
    try {
      return await repository.createUpdateProduct(productLike);
    } catch (e) {
      debugPrint("UpdateProductUsecase execute error: $e");
      return ProductEntity.empty();
    }
  }
}
