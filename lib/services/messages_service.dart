import 'dart:convert';
//import 'dart:html';

import 'package:findmyfun/helpers/helpers.dart';
import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/models/important_notification.dart';
import 'package:findmyfun/models/messages.dart';
import 'package:findmyfun/services/auth_service.dart';
import 'package:findmyfun/services/important_notification_service.dart';
import 'package:findmyfun/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/user.dart';

class MessagesService extends ChangeNotifier {
  final String _baseUrl = Globals.getBaseUrl();
  List<Messages> _messages = [];

  User? currentUser;

  List<Messages> get messages => _messages;

  set messages(List<Messages> inputMessages) {
    _messages = inputMessages;
    notifyListeners();
  }

  //READ MESSAGES
  Future<List<Messages>> getMessages(String eventId) async {
    final url = Uri.https(_baseUrl, 'Events/$eventId/messages.json');
    try {
      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }

      List<Messages> messagesAux = [];
      Map<String, dynamic> data = jsonDecode(resp.body);

      data.forEach((key, value) {
        try {
          final message = Messages.fromRawJson(jsonEncode(value));
          messagesAux.add(message);
        } catch (e) {
          debugPrint('Error parsing message: $e');
        }
      });

      messages = messagesAux;
      return messagesAux;
    } catch (e) {
      throw Exception('Error getting messages: $e');
    }
  }

  Future<void> saveMessage(
      BuildContext context, Messages message, Event event) async {
    String? activeUserId = AuthService().currentUser?.uid;
    // String? activeUserName = AuthService().currentUser?.displayName;
    final usersService = Provider.of<UsersService>(context, listen: false);

    final url = Uri.https(_baseUrl, 'Events/${event.id}/messages.json');
    event.messages.add(message);
    for (var user in event.users) {
      if (user != activeUserId) {
        ImportantNotification notificationChatEvento = ImportantNotification(
            userId: user,
            date: DateTime.now(),
            info:
                "${usersService.currentUser!.name} ha enviado un mensaje en ${event.name}");
        ImportantNotificationService()
            .saveNotification(context, notificationChatEvento, user);
      }
    }
    try {
      // ignore: unused_local_variable
      final resp = await http.post(url, body: jsonEncode(message.toJson()));
    } catch (e) {
      debugPrint('Error posting message: $e');
    }
  }
}
