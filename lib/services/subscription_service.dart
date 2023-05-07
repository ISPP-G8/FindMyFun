import 'dart:convert';
//import 'dart:html';

import 'package:findmyfun/services/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SubscriptionService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  final UsersService usersService = UsersService();
  final currentAuthUser = AuthService().currentUser;

  //UPDATE PROFILE
  Future<bool> updateEventCount(BuildContext context, String userId) async {
    final usersService = Provider.of<UsersService>(context, listen: false);
    final currentUser = usersService.currentUser;
    currentUser!.subscription.numEventsCreatedThisMonth += 1;
    final url = Uri.https(_baseUrl, 'Users/$userId.json');
    try {
      // ignore: unused_local_variable
      final resp = await http.put(url, body: jsonEncode(currentUser));

      if (resp.statusCode != 200) return false;
      return true;
    } catch (e) {
      debugPrint('Error editing profile: $e');
      return false;
    }
  }
}
