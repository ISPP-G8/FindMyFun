import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {
  const ImageBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
                'assets/logo-banner.jpeg',
                width: 200,
              );
  }
}