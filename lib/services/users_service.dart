import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UsersService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  List<dynamic> _users = [];

  User? currentUser;

  List<dynamic> get users => _users;

  void set users(List<dynamic> inputUsers) {
    _users = inputUsers;
    notifyListeners();
  }

  // TODO: Hacer el getItem pasando el uid del AuthService()

  // TODO: Hacer el updateItem pasando el uid del AuthService()

  

  //READ EVENT
  Future<void> getUsers() async {
    final url = Uri.https(_baseUrl, 'Users.json');
     try {

      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        return;
      }

      Map<String, dynamic> data = jsonDecode(resp.body);

      data.forEach((key, value) {
        final user = User.fromRawJson(jsonEncode(value));
        _users.add(user);
      });

    } catch (e) {
      print('Error getting users: $e');
    }
  }
  
}
