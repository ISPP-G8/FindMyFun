import 'dart:convert';

import 'package:findmyfun/models/preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'auth_service.dart';

class PreferencesService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  List<Preferences> _preferences = [];
  Preferences? _preference;
  List<Preferences> _preferencesByUserId = [];

  User? currentUser;

  List<Preferences> get preferences => _preferences;
  Preferences? get preference => _preference;
  List<Preferences> get preferencesByUserId => _preferencesByUserId;

  set preferences(List<Preferences> inputPreferences) {
    _preferences = inputPreferences;
    notifyListeners();
  }

  set preference(Preferences? inputPreference) {
    _preference = inputPreference;
    notifyListeners();
  }

  set preferencesByUserId(List<Preferences> inputPreferences) {
    _preferencesByUserId = inputPreferences;
    notifyListeners();
  }

  //READ PREFERENCES
  Future<List<Preferences>> getPreferences() async {
    final url = Uri.https(_baseUrl, 'Preferences.json');
    try {
      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }

      List<Preferences> preferencesAux = [];
      Map<String, dynamic> data = jsonDecode(resp.body);

      data.forEach((key, value) {
        final preference = Preferences.fromRawJson(jsonEncode(value));
        preferencesAux.add(preference);
      });
      preferences = preferencesAux;
      return preferencesAux;
    } catch (e) {
      throw Exception('Error in response');
    }
  }

  // TODO: De momento no se usa, la dejo por si hace falta
  Future<Preferences> getPreferenceByName(String name) async {
    final url = Uri.https(_baseUrl, 'Preferences.json');
    try {
      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }

      Map<String, dynamic> data = jsonDecode(resp.body);
      Preferences? preferenceAux;
      data.forEach((key, value) {
        final preference = Preferences.fromRawJson(jsonEncode(value));

        if (preference.name == name) {
          preferenceAux = preference;
        }
      });

      if (preferenceAux == null) {
        throw Exception('No existe preferencia');
      }
      preference = preferenceAux;
      return preferenceAux!;
    } catch (e) {
      throw Exception('Error in response');
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
        if (!preferencesByUserId.contains(preference)) {
          print(preference);
          preferencesByUserId.add(preference);
        }
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error getting preferences by user id: $e');
    }
  }

  Future<void> savePreferences(
      String userId, List<dynamic> preferencesToAdd) async {
    try {
      final urlUser = Uri.https(_baseUrl, 'Users/$userId/preferences.json');
      // ignore: unused_local_variable
      final resp = await http.delete(urlUser);

      for (Preferences preference in preferencesToAdd) {
        // ignore: avoid_print
        print(preference.id);
        final urlAdd = Uri.https(
            _baseUrl, 'Users/$userId/preferences/${preference.id}.json');

        // ignore: unused_local_variable
        final respAdd =
            await http.put(urlAdd, body: jsonEncode(preference.toJson()));
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error creating event: $e');
    }
  }
}
