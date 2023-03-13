import 'package:flutter/material.dart';

import '../themes/colors.dart';

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
          color: ProjectColors.secondary,
          borderRadius: BorderRadius.circular(15)),
      child: child,
    );
  }
}