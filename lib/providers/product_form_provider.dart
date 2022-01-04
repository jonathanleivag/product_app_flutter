import 'package:flutter/material.dart';
import 'package:product_app/models/models.dart' show ProductResponseModel;

class ProductFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ProductResponseModel product;
  ProductFormProvider({required this.product});

void changeAvailable(bool value){
  product.available = value;
  notifyListeners();
}

  bool isValidForm() => formKey.currentState?.validate() ?? false;
}
