import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final EdgeInsets? padding;
  final int? maxLines;
  final TextInputType? type;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const CustomTextForm({
    super.key,
    required this.hintText,
    this.obscure = false,
    this.padding,
    this.maxLines,
    this.type = TextInputType.text,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: padding,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        keyboardType: type,
        obscureText: obscure,
        maxLines: maxLines,
        controller: controller,
        validator: validator,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
