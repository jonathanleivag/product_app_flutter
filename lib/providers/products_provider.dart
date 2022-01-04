import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:product_app/models/models.dart' show ProductResponseModel;
import 'package:product_app/utils/utils.dart' show EnvUtil;
import 'package:http/http.dart' as http;

class ProductsProvider extends ChangeNotifier {
  final String _baseUrl = EnvUtil.urlFirebase;
  final List<ProductResponseModel> products = [];
  bool isLoading = true;
  bool isSaving = false;
  File? newPictureFile;
  final storage = const FlutterSecureStorage();

  late ProductResponseModel productsSelected;

  ProductsProvider() {
    loadProducts();
  }

  Future<List<ProductResponseModel>> loadProducts() async {
    isLoading = true;
    notifyListeners();
    final url = Uri.https(
      _baseUrl,
      'products.json',
      {'auth': await storage.read(key: 'token') ?? ''},
    );
    final res = await http.get(url);
    final Map<String, dynamic> productMap = json.decode(res.body);
    productMap.forEach((key, value) {
      final tempProduct = ProductResponseModel.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    isLoading = false;
    notifyListeners();

    return products;
  }

  Future<void> saveOrCreate(ProductResponseModel product) async {
    isSaving = true;
    notifyListeners();
    final String? urlImage = await uploadImage();
    if (urlImage != null) product.picture = urlImage;
    if (product.id == null) {
      await createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(ProductResponseModel product) async {
    final url = Uri.https(
      _baseUrl,
      'products/${product.id}.json',
      {'auth': await storage.read(key: 'token') ?? ''},
    );
    // ignore: unused_local_variable
    final res = await http.put(url, body: product.toJson());
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(ProductResponseModel product) async {
    final url = Uri.https(
      _baseUrl,
      'products.json',
      {'auth': await storage.read(key: 'token') ?? ''},
    );
    final res = await http.post(url, body: product.toJson());
    product.id = json.decode(res.body)['name'];
    products.add(product);
    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    productsSelected.picture = path;
    newPictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (newPictureFile != null) {
      isSaving = true;
      notifyListeners();

      final url = Uri.parse(
          'https://api.cloudinary.com/v1_1/${EnvUtil.cloudName}/image/upload?upload_preset=${EnvUtil.uploadPreset}');
      final imageUploadRequest = http.MultipartRequest('POST', url);
      final file =
          await http.MultipartFile.fromPath('file', newPictureFile!.path);
      imageUploadRequest.files.add(file);
      final streamResponse = await imageUploadRequest.send();
      final resp = await http.Response.fromStream(streamResponse);

      if (resp.statusCode != 201 && resp.statusCode != 200) {
        // ignore: avoid_print
        print('Algo salio mal');
        // ignore: avoid_print
        print(resp.body);
        return null;
      }
      newPictureFile = null;
      return json.decode(resp.body)['secure_url'];
    }
  }
}
