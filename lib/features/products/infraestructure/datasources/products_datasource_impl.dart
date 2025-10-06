import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/datasources/datasources.dart';
import 'package:teslo_shop/features/products/domain/entities/entities.dart';
import 'package:teslo_shop/features/products/infraestructure/mappers/mappers.dart';
import 'package:teslo_shop/shared/infrastructure/simple_adapters.dart';

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
  Future<ProductEntity> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<ProductEntity>> getProductsByPage(int limit, int offset) async {
    final response =
        await dioAdapter.get('/products?limit=$limit&offset=$offset');

    final data = response as List;

    final products =  (data)
        .map((item) => ProductsMapper.fromJsonToEntity(item))
        .toList();

    return products;
  }

  @override
  Future<List<ProductEntity>> getProductsByTerm(String term) {
    // TODO: implement getProductsByTerm
    throw UnimplementedError();
  }
}
