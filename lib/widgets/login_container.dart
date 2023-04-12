import 'package:flutter/material.dart';

class LoginContainer extends StatelessWidget {
  final Widget child;
  const LoginContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.white, blurRadius: 2, spreadRadius: 1)
      ], color: Colors.white),
      child: child,
    );
  }
}
