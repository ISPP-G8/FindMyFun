import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final EdgeInsets? padding;
  final int? maxLines;
  final TextInputType? type;
  final bool enabled;
  const CustomTextForm({
    super.key,
    required this.hintText,
    this.obscure = false,
    this.padding,
    this.maxLines = 1,
    this.type = TextInputType.text,
    this.enabled = true,
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
        obscureText: obscure,
        maxLines: maxLines,
        enabled: enabled,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
