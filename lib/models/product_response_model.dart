// To parse this JSON data, do
//
//     final placesResponse = placesResponseFromMap(jsonString);

import 'dart:convert';

class ProductResponseModel {
  ProductResponseModel({
    required this.available,
    required this.name,
    this.picture,
    required this.price,
    required this.productResponsePrice,
    this.id,
  });

  late bool available;
  late String name;
  String? picture;
  late int price;
  late int productResponsePrice;
  String? id;
  factory ProductResponseModel.fromJson(String str) =>
      ProductResponseModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductResponseModel.fromMap(Map<String, dynamic> json) =>
      ProductResponseModel(
        available: json["available"],
        name: json["name"],
        picture: json["picture"],
        price: json["price"],
        productResponsePrice: json["price"],
      );

  Map<String, dynamic> toMap() => {
        "available": available,
        "name": name,
        "picture": picture,
        "price": price,
        "price ": productResponsePrice,
      };

  ProductResponseModel copy() => ProductResponseModel(
        available: available,
        name: name,
        price: price,
        productResponsePrice: price,
        picture: picture,
        id: id,
      );
}
