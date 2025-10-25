import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/presentation/widgets/widgets.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  void showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final productDetailState =
            ref.watch(productDetailProvider(widget.productId));

        // Si está cargando, muestra loader
        if (productDetailState.isLoading) {
          return const Scaffold(
            body: Center(child: FullScreenLoader()),
          );
        }

        // Si el producto es null, muestra mensaje de error
        if (productDetailState.product == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Editar Producto')),
            body: const Center(
              child: Text(
                'No se pudo cargar el producto. Verifica tu conexión o intenta nuevamente.',
                style: TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Producto cargado correctamente
        final product = productDetailState.product!;
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Editar Producto'),
              actions: [
                IconButton(
                  onPressed: () async {
                    final photoPath =
                        await CameraGalleryAdapterImpl().selectPhoto();
                    if (photoPath == null) return;
                    ref
                        .read(productFormProvider(product).notifier)
                        .onChangeImages([photoPath]);
                  },
                  icon: const Icon(Icons.photo_library_outlined),
                ),
                IconButton(
                  onPressed: () async {
                    final photoPath =
                        await CameraGalleryAdapterImpl().takePhoto();
                    if (photoPath == null) return;
                    ref
                        .read(productFormProvider(product).notifier)
                        .onChangeImages([photoPath]);
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                ),
              ],
            ),
            body: _ProductView(product: product),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                ref
                    .read(productFormProvider(product).notifier)
                    .submitForm()
                    .then((onValue) {
                  if (!mounted) return;
                  if (onValue) {
                    showSnackbar('Producto guardado correctamente');
                  } else {
                    showSnackbar('Error al guardar el producto');
                  }
                });
              },
              child: const Icon(Icons.save_as_outlined),
            ),
          ),
        );
      },
    );
  }
}

class _ProductView extends ConsumerWidget {
  final ProductEntity product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    final productForm = ref.watch(productFormProvider(product));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          SizedBox(
            height: 250,
            width: 600,
            child: _ImageGallery(images: productForm.images),
          ),
          const SizedBox(height: 10),
          Center(
              child: Text(
            productForm.title.value,
            style: textStyles.titleSmall,
            textAlign: TextAlign.center,
          )),
          const SizedBox(height: 10),
          _ProductInformation(product: product),
        ],
      ),
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final ProductEntity product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormProvider(product));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Nombre',
            initialValue: productForm.title.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onChangeTitle,
            errorMessage: productForm.title.errorMessage,
          ),
          CustomProductField(
            label: 'Slug',
            initialValue: productForm.slug.value,
            onChanged:
                ref.read(productFormProvider(product).notifier).onChangeSlug,
            errorMessage: productForm.slug.errorMessage,
          ),
          CustomProductField(
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            initialValue: productForm.price.value.toString(),
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onChangePrice(double.tryParse(value) ?? -1),
            errorMessage: productForm.price.errorMessage,
          ),
          const SizedBox(height: 15),
          const Text('Extras'),
          _SizeSelector(
            selectedSizes: productForm.sizes,
            onSizesChanged: (sizes) => ref
                .read(productFormProvider(product).notifier)
                .onChangeSizes(sizes),
          ),
          const SizedBox(height: 5),
          _GenderSelector(
              selectedGender: productForm.gender,
              onGenderChanged: (gender) => ref
                  .read(productFormProvider(product).notifier)
                  .onChangeGender(gender)),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            initialValue: productForm.stock.value.toString(),
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onChangeStock(int.tryParse(value) ?? -1),
            errorMessage: productForm.stock.errorMessage,
          ),
          CustomProductField(
            maxLines: 6,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: productForm.description,
            onChanged: ref
                .read(productFormProvider(product).notifier)
                .onChangeDescription,
          ),
          CustomProductField(
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: productForm.tags,
            onChanged:
                ref.read(productFormProvider(product).notifier).onChangeTags,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
  final void Function(List<String>) onSizesChanged;

  const _SizeSelector(
      {required this.selectedSizes, required this.onSizesChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 10)));
      }).toList(),
      selected: Set.from(selectedSizes),
      onSelectionChanged: (newSelection) {
        onSizesChanged.call(List.from(newSelection));
        FocusScope.of(context).unfocus(); // Ocultar el teclado al tocar fuera
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final void Function(String) onGenderChanged;
  final List<String> genders = const ['men', 'women', 'kid'];
  final List<IconData> genderIcons = const [
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];

  const _GenderSelector(
      {required this.selectedGender, required this.onGenderChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        emptySelectionAllowed: true,
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: genders.map((size) {
          return ButtonSegment(
              icon: Icon(genderIcons[genders.indexOf(size)]),
              value: size,
              label: Text(size, style: const TextStyle(fontSize: 12)));
        }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {
          onGenderChanged.call(newSelection.first);
          FocusScope.of(context).unfocus(); // Ocultar el teclado al tocar fuera
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover));
    }

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.map((imagePath) {
        late ImageProvider imageProvider;

        imagePath.startsWith('http')
            ? imageProvider = NetworkImage(imagePath)
            : imageProvider = FileImage(File(imagePath));

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: FadeInImage(
              placeholder: const AssetImage('assets/loaders/bottle-loader.gif'),
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        );
      }).toList(),
    );
  }
}
