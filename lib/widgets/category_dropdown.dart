import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';

import '../models/preferences.dart';
import '../services/preferences_service.dart';

class CategoryDropdown extends StatefulWidget {
  const CategoryDropdown({Key? key}) : super(key: key);

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
    debugPrint(prefs.toString());
    debugPrint('AAAAAAAAA');
    // List<String> nombres = preferences.map((e) => e.name.toString()).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: DropDownMultiSelect(
        options: prefs,
        selectedValues: selectedCategories,
        onChanged: (value) {
          print('selected fruit $value');
          setState(() {
            selectedCategories = value;
          });
        },
        whenEmpty: 'Selecciona las categorías del evento',
      ),
    );
  }
}
