import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class CategoryDropdown extends StatefulWidget {
  const CategoryDropdown({Key? key}) : super(key: key);

  @override
  State<CategoryDropdown> createState() => _CategoryDropdown();
}

class _CategoryDropdown extends State<CategoryDropdown> {
  List<String> categories = [
    'Option1',
    'Option2',
    'Option3',
    'Option4',
    'Option5'
  ];
  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: DropDownMultiSelect(
        options: categories,
        selectedValues: selectedCategories,
        onChanged: (value) {
          print('selected fruit $value');
          setState(() {
            selectedCategories = value;
          });
          print('you have selected $selectedCategories fruits.');
        },
        whenEmpty: 'Selecciona las categorías del evento',
      ),
    );
  }
}
