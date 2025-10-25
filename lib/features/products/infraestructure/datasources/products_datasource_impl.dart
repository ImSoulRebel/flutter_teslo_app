import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infraestructure/insfraestructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/drivers/drivers.dart';

class ProductsDatasourceImpl implements ProductsDatasource {
  late final HttpAdapterImpl dioAdapter;
  final String accesToken;

  ProductsDatasourceImpl({required this.accesToken}) {
    dioAdapter = HttpAdapterImpl(
      baseUrl: Environment.apiUrl,
    )..setAuthToken(accesToken);
  }

  Future<String> _uploadImage(String path) async {
    try {
      final fileName = path.split('/').last;

      final formData = FormData.fromMap({
        'file': MultipartFile.fromFileSync(path, filename: fileName),
      });

      final response = await dioAdapter.post('/files/product', formData);
      final image = response['image'] as String;
      return image;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      throw Exception('Image upload failed');
    }
  }

  Future<List<String>> _uploadImages(List<String> paths) async {
    final photosToUpload = paths.where((path) => path.contains('/')).toList();
    final photosToIgnore = paths.where((path) => !path.contains('/')).toList();
    if (photosToUpload.isEmpty) return photosToIgnore;

    final uploadedImages = await Future.wait(photosToUpload.map(_uploadImage));

    return [...photosToIgnore, ...uploadedImages];
  }

  @override
  Future<ProductEntity> createUpdateProduct(
      Map<String, dynamic> productLike) async {
    try {
      final String? id = productLike['id'];
      final data = Map<String, dynamic>.from(productLike)..remove('id');

      if (data.containsKey('images')) {
        final List<String> paths =
            (data['images'] as List).whereType<String>().toList();

        if (paths.isNotEmpty) {
          final uploadedImages = await _uploadImages(paths);
          data['images'] = uploadedImages;
        } else {
          data['images'] = [];
        }
      }

      final response = id != null
          ? await dioAdapter.patch('/products/$id', data)
          : await dioAdapter.post('/products', data);

      return ProductsMapper.fromJsonToEntity(response);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception();
    }
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
