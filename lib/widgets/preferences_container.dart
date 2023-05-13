import 'package:flutter/material.dart';

class PreferencesContainer extends StatelessWidget {
  final Widget child;
  const PreferencesContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height*0.8,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(color: Color(0xff828a92)),
      child: child,
    );
  }
}
