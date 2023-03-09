import 'dart:convert';

import 'package:findmyfun/models/preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class PreferencesService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  List<dynamic> _preferences = [];
  List<dynamic> _preferencesByUserId = [];

  User? currentUser;

  List<dynamic> get preferences => _preferences;
  List<dynamic> get preferencesByUserId => _preferencesByUserId;

  set preferences(List<dynamic> inputPreferences) {
    _preferences = inputPreferences;
    notifyListeners();
  }

  set preferencesByUserId(List<dynamic> inputPreferences) {
    _preferencesByUserId = inputPreferences;
    notifyListeners();
  }

  //READ EVENT
  Future<void> getPreferences() async {
    final url = Uri.https(_baseUrl, 'Preferences.json');
    try {
      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        return;
      }

      Map<String, dynamic> data = jsonDecode(resp.body);
      
      data.forEach((key, value) {
        final preference = Preferences.fromRawJson(jsonEncode(value));
        preferences.add(preference.name);
      });
    } catch (e) {
      print('Error getting preferences: $e');
    }
  }

  Future<void> getPreferencesByUserId(userId) async {
    final url = Uri.https(_baseUrl, 'Users/{$userId}/preferences.json');
    try {
      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        return;
      }

      Map<String, dynamic> data = jsonDecode(resp.body);

      data.forEach((key, value) {
        final preference = Preferences.fromRawJson(jsonEncode(value));
        _preferences.add(preference);
      });
    } catch (e) {
      print('Error getting preferences: $e');
    }
  }
}
