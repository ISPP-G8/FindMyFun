import 'package:flutter/material.dart';

class PreferencesContainer extends StatelessWidget {
  final Widget child;
  const PreferencesContainer({
    super.key, required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: const Color(0xff828a92)),
      child: child,
    );
  }
}