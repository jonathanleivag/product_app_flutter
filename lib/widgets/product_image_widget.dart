import 'dart:io';

import 'package:flutter/material.dart';

class ProductImageWidget extends StatelessWidget {
  final String? url;
  final String id;

  const ProductImageWidget({
    Key? key,
    this.url,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _imagePath() {
      Widget imagePath = Container();
      if (url == null) {
        imagePath = const Image(
          image: AssetImage('assets/images/no-image.png'),
          fit: BoxFit.cover,
        );
      }

      if (url != null && url!.startsWith('http')) {
        imagePath = FadeInImage(
          image: NetworkImage(url!),
          placeholder: const AssetImage('assets/images/jar-loading.gif'),
          fit: BoxFit.cover,
        );
      }

      if (url != null && !url!.startsWith('http')) {
        imagePath = Image.file(
          File(url!),
          fit: BoxFit.cover,
        );
      }
      return imagePath;
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      child: Container(
        height: 450,
        width: double.infinity,
        decoration: _boxDecoration(),
        child: Opacity(
          opacity: 0.9,
          child: ClipRRect(
            borderRadius: _borderRadius(),
            child: Hero(tag: id, child: _imagePath()),
          ),
        ),
      ),
    );
  }

  BorderRadius _borderRadius() {
    return const BorderRadius.only(
      topLeft: Radius.circular(45),
      topRight: Radius.circular(45),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.black,
      borderRadius: _borderRadius(),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5))
      ],
    );
  }
}
