import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';

import '../models/preferences.dart';
import '../services/preferences_service.dart';

class CategoryDropdown extends StatefulWidget {
  final List<Object>? selectedValues;
  final Function(List<Object>) onSelectionChanged;
  const CategoryDropdown({
    Key? key,
    this.selectedValues,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<CategoryDropdown> createState() => _CategoryDropdown();
}

class _CategoryDropdown extends State<CategoryDropdown> {
  List<Object> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    final preferencesService = Provider.of<PreferencesService>(context);
    preferencesService.getPreferences();
    List<String> prefs =
        preferencesService.preferences.map((e) => e.name).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white),
      child: DropDownMultiSelect(
        options: prefs,
        selectedValues: selectedCategories,
        onChanged: (value) {
          print('selected category $value');
          setState(() {
            selectedCategories = value;
            widget.onSelectionChanged(value);
          });
          widget.onSelectionChanged.call(selectedCategories);
        },
        whenEmpty: 'Selecciona las categorías del evento',
      ),
    );
  }
}
