import 'package:flutter/foundation.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class LoadNextPageUsecase {
  final ProductsRepository repository;

  LoadNextPageUsecase(this.repository);

  Future<List<ProductEntity>> execute(int limit, int offset) async {
    try {
      return await repository.getProductsByPage(limit, offset);
    } catch (e) {
      debugPrint("LoadNextPageUsecase execute error: $e");
      return [];
    }
  }
}
