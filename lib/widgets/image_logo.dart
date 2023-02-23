import 'package:flutter/material.dart';

class ImageLogo extends StatelessWidget {
  const ImageLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
                'assets/logo.jpeg',
                width: 200,
              );
  }
}