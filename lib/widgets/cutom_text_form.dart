import 'package:findmyfun/themes/themes.dart';
import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const CustomTextForm({
    super.key,
    required this.hintText,
    this.obscure = false,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        textAlign: TextAlign.center,
        validator: validator,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
