import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/products/domain/entities/products_entity.dart';
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
  final void Function(Map<String, dynamic> productLike)? onSubmitCallback;
  late final ProductEntity product;

  ProductProviderFormNotifier({
    this.onSubmitCallback,
    required this.product,
  });

  @override
  ProductProviderFormState build() {
    return ProductProviderFormState(
      id: product.id,
      title: TitleInput.dirty(product.title),
      slug: SlugInput.dirty(product.slug),
      price: PriceInput.dirty(product.price),
      stock: StockInput.dirty(product.stock),
      sizes: product.sizes,
      description: product.description,
      tags: product.tags.join(', '),
    );
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
