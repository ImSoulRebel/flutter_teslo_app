import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infraestructure/insfraestructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/drivers/drivers.dart';

class ProductsDatasourceImpl implements ProductsDatasource {
  late final DioAdapter dioAdapter;
  final String accesToken;

  ProductsDatasourceImpl({required this.accesToken}) {
    dioAdapter = DioAdapter(
      baseUrl: Environment.apiUrl,
    )..setAuthToken(accesToken);
  }

  @override
  Future<ProductEntity> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(String id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<ProductEntity> getProductById(String id) async {
    try {
      final response = await dioAdapter.get('/products/$id');
      final product = ProductsMapper.fromJsonToEntity(response);
      return product;
    } on DioException catch (e) {
      debugPrint("ProductsDatasourceImpl getProductById DioException: $e");
      if (e.response?.statusCode == 404) throw ProductNotFound();
      throw Exception();
    } catch (e) {
      debugPrint("ProductsDatasourceImpl getProductById error: $e");
      throw Exception();
    }
  }

  @override
  Future<List<ProductEntity>> getProductsByPage(int limit, int offset) async {
    final response =
        await dioAdapter.get('/products?limit=$limit&offset=$offset');

    final data = response as List;

    final products =
        (data).map((item) => ProductsMapper.fromJsonToEntity(item)).toList();

    return products;
  }

  @override
  Future<List<ProductEntity>> getProductsByTerm(String term) {
    // TODO: implement getProductsByTerm
    throw UnimplementedError();
  }
}
