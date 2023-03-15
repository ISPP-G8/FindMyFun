import 'package:flutter/material.dart';

import '../themes/colors.dart';

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
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black54, blurRadius: 2, spreadRadius: 1)
      ], color: ProjectColors.secondary),
      child: child,
    );
  }
}
