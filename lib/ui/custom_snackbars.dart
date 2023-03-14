import 'package:flutter/material.dart';

class CustomSnackbars {
  static showCustomSnackbar(BuildContext context, Widget widget) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: widget,
      duration: const Duration(seconds: 1),
    ));
  }
}
