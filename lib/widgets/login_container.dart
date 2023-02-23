import 'package:flutter/material.dart';

class LoginContainer extends StatelessWidget {
  final Widget child;
  const LoginContainer({
    super.key, required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: const Color(0xff828a92),
          borderRadius: BorderRadius.circular(15)),
      child: child,
    );
  }
}