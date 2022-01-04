import 'package:flutter/material.dart';
import 'package:product_app/views/views.dart';

Map<String, Widget Function(BuildContext)> router = {
  LoginView.routerName: (_) => const LoginView(),
  HomeView.routerName: (_) => const HomeView(),
  ProductView.routerName: (_) => const ProductView(),
  RegisterView.routerName: (_) => const RegisterView(),
  CheckAuthView.routerName: (_) => const CheckAuthView(),
};
