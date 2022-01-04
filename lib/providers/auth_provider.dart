import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/utils/utils.dart' show EnvUtil;

class AuthProvider extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _apiWebKey = EnvUtil.apiWebKeyFirebase;
  String? _respReturn;
  final storage = const FlutterSecureStorage();

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _apiWebKey});
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('error')) {
      _respReturn = decodedResp['error']['message'];
    } else {
      await storage.write(key: 'token', value: decodedResp['idToken']);
      _respReturn = null;
    }

    return _respReturn;
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    };

    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _apiWebKey});
    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('error')) {
      _respReturn = decodedResp['error']['message'];
    } else {
      await storage.write(key: 'token', value: decodedResp['idToken']);
      _respReturn = null;
    }

    return _respReturn;
  }

  Future<void> logout() async => await storage.delete(key: 'token');

  Future<String> readToken() async => await storage.read(key: 'token') ?? '';
}
