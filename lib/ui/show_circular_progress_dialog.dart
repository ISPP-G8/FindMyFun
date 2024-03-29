import 'package:flutter/material.dart';

Future<void> showCircularProgressDialog(BuildContext context,
    {bool dismissible = false}) async {
  await showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          SizedBox(height: 50, width: 50, child: CircularProgressIndicator()),
        ]),
  );
}
