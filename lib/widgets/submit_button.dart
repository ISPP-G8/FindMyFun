import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SubmitButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final EdgeInsetsGeometry? margin;
  const SubmitButton({
    super.key,
    required this.text,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin:
            margin ?? const EdgeInsets.symmetric(horizontal: 110, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: const BoxDecoration(color: Color(0xff004aad)),
        child: AutoSizeText(
          text,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(
              0xffffde59,
            ),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
