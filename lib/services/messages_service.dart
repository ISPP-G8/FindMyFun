import 'dart:convert';
//import 'dart:html';

import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/models/messages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class MessagesService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  List<Messages> _messages = [];

  User? currentUser;

  List<Messages> get messages => _messages;

  set messages(List<Messages> inputMessages) {
    _messages = inputMessages;
    notifyListeners();
  }
  // TODO: Hacer el updateItem pasando el uid del AuthService()

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

  Future<void> saveMessage(Messages message, Event event) async {
    final url = Uri.https(_baseUrl, 'Events/${event.id}/messages.json');
    event.messages.add(message);
    try {
      // ignore: unused_local_variable
      final resp = await http.post(url, body: jsonEncode(message.toJson()));
    } catch (e) {
      debugPrint('Error posting message: $e');
    }
  }
}
