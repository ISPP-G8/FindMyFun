import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/user.dart';
import 'users_service.dart';

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

  //FIND EVENTS
  Future<bool> findEvents() async {
    final url = Uri.https(_baseUrl, 'Events.json');
    final UsersService usersService = UsersService();
    
    // TODO: Always null cause user is not created yet
    User? currentUser = usersService.currentUser;

    if (currentUser == null) {
      debugPrint('Error currentUser is $currentUser');
      return false;
    }

    try {
      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        return false;
      }
      List<Event> eventsAux = [];
      Map<String, dynamic> data = jsonDecode(resp.body);

      data.forEach((key, value) {
        final event = Event.fromRawJson(jsonEncode(value));
        if (currentUser.preferences.toSet().intersection(event.tags.toSet()).isNotEmpty/* && currentUser.city == event.city*/) {
          eventsAux.add(event);
        }
      });
      events = eventsAux;

      return true;
    } catch (e) {
      debugPrint('Error getting events: $e');
      return false;
    }
  }
}
