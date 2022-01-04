import 'package:flutter/material.dart';
import 'package:product_app/models/product_response_model.dart';
import 'package:product_app/providers/providers.dart'
    show ProductsProvider, AuthProvider;
import 'package:product_app/views/views.dart';
import 'package:product_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  static String routerName = 'HomeView';

  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    if (productsProvider.isLoading) return const LoadingView();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        leading: IconButton(
            onPressed: () {
              final AuthProvider authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              authProvider.logout();
              Navigator.of(context).popAndPushNamed(LoginView.routerName);
            },
            icon: const Icon(Icons.logout_outlined)),
      ),
      body: ListView.builder(
        itemCount: productsProvider.products.length,
        itemBuilder: (_, index) => ProductCardWidget(
          product: productsProvider.products[index],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productsProvider.productsSelected = ProductResponseModel(
            available: false,
            name: '',
            price: 0,
            productResponsePrice: 0,
          );
          Navigator.pushNamed(context, ProductView.routerName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
