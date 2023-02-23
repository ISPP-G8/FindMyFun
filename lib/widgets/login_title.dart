import 'package:flutter/material.dart';

class LoginTitle extends StatelessWidget {
  final String text;
  const LoginTitle({
    super.key, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      width: double.infinity,
      alignment: Alignment.center,
      child:  Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),
      ),
    );
  }
}
