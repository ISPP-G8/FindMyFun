import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  final String checkboxText;

  const CustomCheckbox({super.key, required this.checkboxText});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            widget.checkboxText,
            style: const TextStyle(color: Colors.black54),
          ),
          Checkbox(
            checkColor: Colors.white,
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            },
          )
        ],
      ),
    );
  }
}
