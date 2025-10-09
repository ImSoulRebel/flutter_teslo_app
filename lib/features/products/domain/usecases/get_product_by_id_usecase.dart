import 'package:flutter/foundation.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class GetProductByIdUsecase {
  final ProductsRepository repository;

  GetProductByIdUsecase(this.repository);

  Future<ProductEntity> execute(String id) async {
    try {
      return await repository.getProductById(id);
    } catch (e) {
      debugPrint("GetProductByIdUsecase execute error: $e");
      rethrow;
    }
  }
}
