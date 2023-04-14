import 'package:findmyfun/themes/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final double? width;

  const CustomButton(
      {super.key,
      required this.text,
      this.onTap,
      this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
            color: const Color(0xff004aad),
            borderRadius: BorderRadius.circular(15)),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color(0xffffde59),
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
    );
  }
}
