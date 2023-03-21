import 'package:flutter/material.dart';

class UsersContainer extends StatelessWidget {
  final Widget child;
  const UsersContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 242, 242),
          borderRadius: BorderRadius.circular(15)),
      child: child,
    );
  }
}
