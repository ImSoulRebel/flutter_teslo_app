import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/constants/constants.dart';
import 'package:teslo_shop/features/products/domain/entities/products_entity.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/infrastructure/infra/infrastructure.dart';

class ProductProviderFormState {
  final bool isValid;
  final String id;
  final String description;
  final String tags;
  final String gender;
  final List<String> images;
  final List<String> sizes;
  final TitleInput title;
  final SlugInput slug;
  final PriceInput price;
  final StockInput stock;

  ProductProviderFormState({
    this.isValid = false,
    this.id = '',
    this.tags = '',
    this.gender = '',
    this.description = '',
    this.images = const [],
    this.sizes = const [],
    this.stock = const StockInput.pure(),
    this.title = const TitleInput.pure(),
    this.slug = const SlugInput.pure(),
    this.price = const PriceInput.pure(),
  });

  ProductProviderFormState copyWith({
    bool? isValid,
    String? id,
    String? description,
    String? tags,
    String? gender,
    List<String>? images,
    List<String>? sizes,
    TitleInput? title,
    SlugInput? slug,
    PriceInput? price,
    StockInput? stock,
  }) =>
      ProductProviderFormState(
        isValid: isValid ?? this.isValid,
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        price: price ?? this.price,
        sizes: sizes ?? this.sizes,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        gender: gender ?? this.gender,
        stock: stock ?? this.stock,
        images: images ?? this.images,
      );
}

class ProductProviderFormNotifier extends Notifier<ProductProviderFormState> {
  late Future<bool> Function(Map<String, dynamic> productLike)?
      onSubmitCallback;
  late final ProductEntity product;

  ProductProviderFormNotifier({
    required this.product,
  });

  @override
  ProductProviderFormState build() {
    onSubmitCallback =
        ref.read(productsProvider.notifier).createOrUpdateProduct;

    return ProductProviderFormState(
      id: product.id,
      title: TitleInput.dirty(product.title),
      slug: SlugInput.dirty(product.slug),
      price: PriceInput.dirty(product.price),
      stock: StockInput.dirty(product.stock),
      sizes: product.sizes,
      description: product.description,
      images: product.images,
      gender: product.gender,
      tags: product.tags.join(', '),
    );
  }

  void _formValidation() {
    state = state.copyWith(
      isValid: Formz.validate([
        TitleInput.dirty(state.title.value),
        SlugInput.dirty(state.slug.value),
        PriceInput.dirty(state.price.value),
        StockInput.dirty(state.stock.value),
      ]),
    );
  }

  Future<bool> submitForm() async {
    _formValidation();
    if (!state.isValid) return false;
    if (onSubmitCallback == null) return false;

    final parsedTags = state.tags
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
    final parsedImages = state.images
        .map((img) => img.replaceAll(
              '${Environment.apiUrl}/files/product/',
              '',
            ))
        .toList();

    final productLike = {
      'id': state.id,
      'title': state.title.value,
      'slug': state.slug.value,
      'price': state.price.value,
      'sizes': state.sizes,
      'description': state.description,
      'gender': state.gender,
      'stock': state.stock.value,
      'tags': parsedTags,
      'images': parsedImages,
    };

    try {
      return await onSubmitCallback!(productLike);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  void onChangeTitle(String value) {
    final title = TitleInput.dirty(value);
    state = state.copyWith(
      title: title,
      isValid: Formz.validate([
        title,
        SlugInput.dirty(state.slug.value),
        PriceInput.dirty(state.price.value),
        StockInput.dirty(state.stock.value),
      ]),
    );
  }

  void onChangeSlug(String value) {
    final slug = SlugInput.dirty(value);
    state = state.copyWith(
      slug: slug,
      isValid: Formz.validate([
        TitleInput.dirty(state.title.value),
        slug,
        PriceInput.dirty(state.price.value),
        StockInput.dirty(state.stock.value),
      ]),
    );
  }

  void onChangePrice(double value) {
    final price = PriceInput.dirty(value);
    state = state.copyWith(
      price: price,
      isValid: Formz.validate([
        TitleInput.dirty(state.slug.value),
        SlugInput.dirty(state.slug.value),
        price,
        StockInput.dirty(state.stock.value),
      ]),
    );
  }

  void onChangeStock(int value) {
    final stock = StockInput.dirty(value);
    state = state.copyWith(
      stock: stock,
      isValid: Formz.validate([
        TitleInput.dirty(state.slug.value),
        SlugInput.dirty(state.slug.value),
        PriceInput.dirty(state.price.value),
        stock,
      ]),
    );
  }

  void onChangeSizes(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  void onChangeDescription(String description) {
    state = state.copyWith(description: description);
  }

  void onChangeTags(String tags) {
    state = state.copyWith(tags: tags);
  }

  void onChangeGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onChangeImages(List<String> images) {
    state = state.copyWith(images: images);
  }
}

final productFormProvider = NotifierProvider.autoDispose.family<
        ProductProviderFormNotifier, ProductProviderFormState, ProductEntity>(
    (product) => ProductProviderFormNotifier(
          product: product,
        ));
