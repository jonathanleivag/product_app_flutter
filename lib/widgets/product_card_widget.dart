import 'package:flutter/material.dart';
import 'package:product_app/models/models.dart' show ProductResponseModel;
import 'package:product_app/providers/providers.dart';
import 'package:product_app/views/product_view.dart';
import 'package:provider/provider.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductResponseModel product;

  const ProductCardWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          offset: Offset(0, 7),
          blurRadius: 10,
        )
      ],
    );

    return GestureDetector(
      onTap: () {
        final productsProvider =
            Provider.of<ProductsProvider>(context, listen: false);
        productsProvider.productsSelected = product.copy();
        Navigator.pushNamed(
          context,
          ProductView.routerName,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Container(
          margin: const EdgeInsets.only(
            top: 30,
            bottom: 50,
          ),
          height: 400,
          width: double.infinity,
          decoration: boxDecoration,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              _BackgrounImage(
                url: product.picture,
                id: product.id!,
              ),
              _ProductDetails(
                id: product.id!,
                title: product.name,
              ),
              _TagPrice(
                price: product.price,
              ),
              if (!product.available) const _NotAvailable()
            ],
          ),
        ),
      ),
    );
  }
}

class _TagPrice extends StatelessWidget {
  final int price;
  const _TagPrice({Key? key, required this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              '\$${price.toString()}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        width: 100,
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
      ),
    );
  }
}

class _NotAvailable extends StatelessWidget {
  const _NotAvailable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        alignment: Alignment.center,
        child: const FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Text(
              'No disponible',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        width: 100,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.yellow[800],
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
        ),
      ),
    );
  }
}

class _BackgrounImage extends StatelessWidget {
  final String? url;
  final String id;

  const _BackgrounImage({
    Key? key,
    this.url,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: Hero(
          tag: id,
          child: url != null
              ? FadeInImage(
                  placeholder:
                      const AssetImage('assets/images/jar-loading.gif'),
                  image: NetworkImage(url!),
                  fit: BoxFit.cover,
                )
              : const Image(
                  image: AssetImage('assets/images/no-image.png'),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final String title;
  final String id;

  const _ProductDetails({
    Key? key,
    required this.title,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const BoxDecoration boxDecoration = BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(25),
        bottomLeft: Radius.circular(25),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: boxDecoration,
        height: 70,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              id,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
