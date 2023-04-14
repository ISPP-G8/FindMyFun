import 'dart:convert';

import 'package:findmyfun/services/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:findmyfun/models/important_notification.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class ImportantNotificationService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  List<ImportantNotification?> _notifications = [];

  User? currentUser;

  List<ImportantNotification?> get notifications => _notifications;

  set notifications(List<ImportantNotification?> inputNotifications) {
    _notifications = inputNotifications;
    notifyListeners();
  }

  //READ NOTIFICATIONS
  Future<void> getNotifications(String userId) async {
    final url = Uri.https(_baseUrl, 'Users/${userId}.json');
    try {
      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }
      final User currentUser = User.fromJson(jsonDecode(resp.body));
      notifications = currentUser.notifications;

      // List<ImportantNotification> notificationAux = [];

      // print(resp.body);
      // Map<String, dynamic> data = jsonDecode(resp.body);

      // data.forEach((key, value) {
      //   try {
      //     final notification =
      //         ImportantNotification.fromRawJson(jsonEncode(value));

      //     notificationAux.add(notification);
      //   } catch (e) {
      //     debugPrint('Error parsing notification: $e');
      //   }
      // });

      // notifications = notificationAux;
      // return notificationAux;
    } catch (e) {
      throw Exception('Error getting notification: $e');
    }
  }

  //SAVE NOTIFICATION
  Future<void> saveNotification(BuildContext context,
      ImportantNotification notification, String userId) async {
    final usersService = Provider.of<UsersService>(context, listen: false);
    final currentUser = usersService.currentUser;
    currentUser!.notifications.add(notification);
    final url = Uri.https(_baseUrl, 'Users/${userId}.json');
    try {
      final resp = await http.put(url, body: jsonEncode(currentUser));
    } catch (e) {
      debugPrint('Error posting notification: $e');
    }
  }
}
