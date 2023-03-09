import 'dart:convert';

import 'package:findmyfun/services/auth_service.dart';
import 'package:findmyfun/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/user.dart';

class EventsService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  List<Event> _events = [];

  List<Event> get events => _events;

  set events(List<Event> inputEvents) {
    _events = inputEvents;
    notifyListeners();
  }

  Future<void> deleteEvent(String eventId) async {
    final url = Uri.https(_baseUrl, 'Events/$eventId.json');
    try {
      final resp = await http.delete(url);

      print(resp.body);
    } catch (e) {
      print('Error al eliminar el evento: $e');
    }
  }

  //POST AND UPDATE EVENT
  Future<void> saveEvent(Event event) async {
    final url = Uri.https(_baseUrl, 'Events/${event.id}.json');
    try {
      final resp = await http.put(url, body: jsonEncode(event.toJson()));
    } catch (e) {
      print('Error creating event: $e');
    }
  }

  //READ EVENT
  Future<bool> getEvents() async {
    final url = Uri.https(_baseUrl, 'Events.json');
    try {
      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        return false;
      }
      List<Event> eventsAux = [];
      Map<String, dynamic> data = jsonDecode(resp.body);

      data.forEach((key, value) {
        final event = Event.fromRawJson(jsonEncode(value));

        eventsAux.add(event);
      });
      events = eventsAux;

      return true;
    } catch (e) {
      print('Error getting events: $e');
      return false;
    }
  }

  Future<void> addUser(Event event, User user) async {
    String eventId = event.id;
    String activeUserId = AuthService().currentUser?.uid ?? "";
    if (activeUserId.isEmpty || eventId.isEmpty || event.users.contains(user)) {
      throw Exception(
          'Be sure to be logged, make sure that the event exists and check if you aren´t already part of the event');
    } else {
      event.users.add(user);
      final url = Uri.https(_baseUrl, 'Events/$eventId.json');
      final resp = await http.put(url, body: jsonEncode(event.toJson()));
    }
  }
}
