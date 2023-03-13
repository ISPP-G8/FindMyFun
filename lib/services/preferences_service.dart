import 'dart:convert';

import 'package:findmyfun/models/preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'auth_service.dart';

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

  //READ PREFERENCES
  Future<void> getPreferences() async {
    final url = Uri.https(_baseUrl, 'Preferences.json');
    try {
      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        return;
      }

      Map<String, dynamic> data = jsonDecode(resp.body);
      print(data);
      data.forEach((key, value) {
        final preference = Preferences.fromRawJson(jsonEncode(value));
        if(!preferences.contains(preference)){
          preferences.add(preference);
        }  
      });
    } catch (e) {
      print('Error getting all preferences: $e');
    }
  }

  Future<void> getPreferencesByUserId() async {
    String activeUserId = AuthService().currentUser?.uid ?? "";
    final url = Uri.https(_baseUrl, 'Users/{$activeUserId}/preferences.json');
    try {
      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        return;
      }

      Map<String, dynamic> data = jsonDecode(resp.body);

      data.forEach((key, value) {
        final preference = Preferences.fromRawJson(jsonEncode(value));
        if(!preferences.contains(preference)){
          preferences.add(preference);
        }  
      });
    } catch (e) {
      print('Error getting preferences by user id: $e');
    }
  }

  Future<void> savePreferences(
      String userId, List<dynamic> preferencesToAdd) async {
    try {
      final urlUser = Uri.https(_baseUrl, 'Users/$userId/preferences.json');
      final resp = await http.delete(urlUser);

      for (Preferences preference in preferencesToAdd) {
        print(preference.id);
        final urlAdd = Uri.https(
            _baseUrl, 'Users/$userId/preferences/${preference.id}.json');

        final respAdd =
            await http.put(urlAdd, body: jsonEncode(preference.toJson()));
      }
    } catch (e) {
      print('Error creating event: $e');
    }
  }
}
