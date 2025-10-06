import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/infraestructure/infraestructure.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';

class ProductsMapper {
  static ProductEntity fromJsonToEntity(Map<String, dynamic> json) {
    final List<String> imagesPath = List<String>.from(json["images"])
        .map((image) => image.contains('http')
            ? image
            : '${Environment.apiUrl}/files/product/$image')
        .toList();

    return ProductEntity(
      id: json["id"],
      title: json["title"],
      price: json["price"].toDouble(),
      description: json["description"],
      slug: json["slug"],
      stock: json["stock"].toInt(),
      sizes: List<String>.from(json["sizes"]),
      gender: json["gender"],
      tags: List<String>.from(json["tags"]),
      images: imagesPath,
      user: UserMapper.fromJsonToEntity(json["user"]),
    );
  }
}
