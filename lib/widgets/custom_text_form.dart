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
  final String? initialValue;

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
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: padding,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 160, 156, 156),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color.fromARGB(96, 247, 247, 247),
          width: 2,
        ),
      ),
      child: TextFormField(
        keyboardType: type,
        controller: controller,
        obscureText: obscure,
        maxLines: maxLines,
        enabled: enabled,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 26, color: Colors.black),
        validator: validator,
        initialValue: initialValue,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
              color: Color.fromARGB(221, 90, 87, 87), fontSize: 26),
          border: InputBorder.none,
          errorStyle: const TextStyle(color: Color.fromARGB(255, 243, 37, 22)),
        ),
      ),
    );
  }
}
