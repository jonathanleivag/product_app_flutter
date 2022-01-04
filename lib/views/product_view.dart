import 'package:flutter/material.dart';
import 'package:product_app/models/product_response_model.dart';
import 'package:product_app/providers/providers.dart';
import 'package:product_app/ui/ui.dart';
import 'package:product_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProductView extends StatelessWidget {
  static String routerName = 'ProductView';
  const ProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    return ChangeNotifierProvider(
        create: (_) =>
            ProductFormProvider(product: productsProvider.productsSelected),
        child: _ProductViewBody(productsProvider: productsProvider));
  }
}

class _ProductViewBody extends StatelessWidget {
  const _ProductViewBody({
    Key? key,
    required this.productsProvider,
  }) : super(key: key);

  final ProductsProvider productsProvider;

  @override
  Widget build(BuildContext context) {
    final ProductFormProvider productFormProvider =
        Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImageWidget(
                    url: productsProvider.productsSelected.picture,
                    id: productsProvider.productsSelected.id ?? ''),
                const _IconBack(),
                const _Camera(),
                const _Galeria(),
              ],
            ),
            const _ProductForm(),
            const SizedBox(height: 100)
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: productsProvider.isSaving
            ? null
            : () async {
                if (productFormProvider.isValidForm()) {
                  await productsProvider
                      .saveOrCreate(productFormProvider.product);
                }
              },
        child: productsProvider.isSaving
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(Icons.save_outlined),
      ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: _boxDecoration(),
        child: const _Form(),
      ),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 5),
          )
        ],
      );
}

class _Form extends StatelessWidget {
  const _Form({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductFormProvider productFormProvider =
        Provider.of<ProductFormProvider>(context);
    final ProductResponseModel product = productFormProvider.product;
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: productFormProvider.formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          TextFormField(
            initialValue: product.name,
            onChanged: (value) => product.name = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El nombre es obligatorio';
              }
            },
            decoration: InputDecorationUI.authDecoration(
              hintText: 'Nombre del producto',
              labelText: 'Nombre: ',
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            initialValue: product.price.toString(),
            onChanged: (value) {
              if (int.tryParse(value) == null) {
                product.price = 0;
              } else {
                product.price = int.parse(value);
              }
            },
            keyboardType: TextInputType.number,
            decoration: InputDecorationUI.authDecoration(
              hintText: '\$5000',
              labelText: 'Precio: ',
            ),
          ),
          const SizedBox(height: 30),
          SwitchListTile.adaptive(
            value: product.available,
            title: const Text('Disponible'),
            activeColor: Colors.indigo,
            onChanged: productFormProvider.changeAvailable,
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class _Camera extends StatelessWidget {
  const _Camera({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context);

    return Positioned(
      top: 60,
      right: 20,
      child: IconButton(
        onPressed: () async {
          final ImagePicker _picker = ImagePicker();
          final XFile? photo = await _picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 100,
          );

          if (photo != null) {
            productsProvider.updateSelectedProductImage(photo.path);
          }
        },
        icon: const Icon(
          Icons.camera_alt_outlined,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _Galeria extends StatelessWidget {
  const _Galeria({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context);

    return Positioned(
      top: 60,
      right: 70,
      child: IconButton(
        onPressed: () async {
          final ImagePicker _picker = ImagePicker();
          final XFile? photo = await _picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 100,
          );

          if (photo != null) {
            productsProvider.updateSelectedProductImage(photo.path);
          }
        },
        icon: const Icon(
          Icons.photo,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _IconBack extends StatelessWidget {
  const _IconBack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 20,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.arrow_back_ios_new,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }
}
