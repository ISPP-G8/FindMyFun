import 'package:flutter/material.dart';

class CustomTextDetail extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final EdgeInsets? padding;
  final int? maxLines;
  final TextInputType? type;
  final bool enabled;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? initialValue;

  const CustomTextDetail({
    super.key,
    required this.hintText,
    this.obscure = false,
    this.padding = const EdgeInsets.all(10),
    this.maxLines = 1,
    this.type = TextInputType.text,
    this.enabled = true,
    this.controller,
    this.validator,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: padding,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        border: Border.all(
            color: const Color.fromARGB(96, 247, 247, 247), width: 2),
      ),
      child: TextFormField(
        keyboardType: type,
        controller: controller,
        obscureText: obscure,
        maxLines: maxLines,
        enabled: enabled,
        textAlign: TextAlign.center,
        validator: validator,
        initialValue: initialValue,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black87, fontSize: 26),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
