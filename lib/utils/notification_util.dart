import 'package:flutter/material.dart';

class NotificationUtil {
  static GlobalKey<ScaffoldMessengerState> globalKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
    globalKey.currentState!.showSnackBar(snackBar);
  }
}
