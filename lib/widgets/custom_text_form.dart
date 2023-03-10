import 'package:findmyfun/themes/themes.dart';
import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final EdgeInsets? padding;
  final int? maxLines;
  final TextInputType? type;
  final bool enabled;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const CustomTextForm({
    super.key,
    required this.hintText,
    this.obscure = false,
    this.padding = const EdgeInsets.all(10),
    this.maxLines = 1,
    this.type = TextInputType.text,
    this.enabled = true,
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        keyboardType: type,
        controller: controller,
        obscureText: obscure,
        maxLines: maxLines,
        enabled: enabled,
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
