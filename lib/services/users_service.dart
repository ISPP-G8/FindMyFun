import 'dart:convert';
//import 'dart:html';

import 'package:findmyfun/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UsersService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  List<User> _users = [];

  User? currentUser;

  List<User> get users => _users;

  void set users(List<User> inputUsers) {
    _users = inputUsers;
    notifyListeners();
  }

  // TODO: Hacer el getItem pasando el uid del AuthService()
  Future<User> getUserWithUid(String userUid) async {
    final url = Uri.https(_baseUrl, 'Users/$userUid.json');
    User user;
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(resp.body);
        user = User.fromJson(data);
        return user;
      } else {
        throw Exception(
            'Errors ocurred while trying to get the user with Uid $userUid');
      }
    } catch (e) {
      throw Exception('The user $e couldn´t be found.');
    }
  }

  Future<void> getCurrentUserWithUid() async {
    String activeUserId = AuthService().currentUser?.uid ?? "";
    final url = Uri.https(_baseUrl, 'Users/$activeUserId.json');
    User user;
    try {
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(resp.body);
        user = User.fromJson(data);
        currentUser = user;
      } else {
        throw Exception(
            'Errors ocurred while trying to get the current user with Uid $activeUserId');
      }
    } catch (e) {
      throw Exception('The current user $e couldn´t be found.');
    }
  }
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

  //UPDATE PROFILE
  Future<void> updateProfile(User user) async {
    final url = Uri.https(_baseUrl, 'Users/${user.id}.json');
    try {
      final resp = await http.put(url, body: jsonEncode(user.toJson()));
    } catch (e) {
      debugPrint('Error editing profile: $e');
    }
  }

  //DELETE PROFILE
  Future<void> deleteProfile(User user, BuildContext context) async {
    final url = Uri.https(_baseUrl, 'Users/${user.id}.json');
    try {
      final resp = await http.delete(url);
      AuthService().signOut;
      await Navigator.pushNamed(context, 'access');
    } catch (e) {
      debugPrint('Error deleting profile: $e');
    }
  }

}
