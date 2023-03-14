import 'dart:async';
import 'dart:convert';

import 'package:findmyfun/models/preferences.dart';
import 'package:findmyfun/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/event.dart';
import '../models/user.dart';
import 'users_service.dart';

class EventsService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  List<Event> _events = [];
  List<Event> _eventsFound = [];

  List<Event> get events => _events;
  List<Event> get eventsFound => _eventsFound;

  set events(List<Event> inputEvents) {
    _events = inputEvents;
    notifyListeners();
  }

  set eventsFound(List<Event> inputEvents) {
    _eventsFound = inputEvents;
    notifyListeners();
  }

  Future<void> deleteEvent(String eventId) async {
    final url = Uri.https(_baseUrl, 'Events/$eventId.json');
    try {
      final resp = await http.delete(url);
      debugPrint(resp.body);
    } catch (e) {
      debugPrint('Error al eliminar el evento: $e');
    }
  }

  //POST AND UPDATE EVENT
  Future<void> saveEvent(Event event) async {
    final url = Uri.https(_baseUrl, 'Events/${event.id}.json');
    try {
      final resp = await http.put(url, body: jsonEncode(event.toJson()));
    } catch (e) {
      debugPrint('Error creating event: $e');
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
      debugPrint('Error getting events: $e');
      return false;
    }
  }

  Future<void> updateEvent(Event event) async {
    final url = Uri.https(_baseUrl, 'Events/${event.id}.json');
    String eventCreator = event.creator;
    String getCreator = '';
    try {
      final get = await http.get(url);
      final jsonResponse = json.decode(get.body);
      List<dynamic> getUsers = jsonResponse['users'];
      getCreator = getUsers.first;
    } catch (e) {
      print('Error creating event: $e');
    }
    if (eventCreator == getCreator) {
      try {
        final put = await http.put(url, body: jsonEncode(event.toJson()));
      } catch (e) {
        print('Error creating event: $e');
      }
    }
  }

  //FIND EVENTS
  Future<List<Event>> findEvents() async {
    final url = Uri.https(_baseUrl, 'Events.json');
    final UsersService usersService = UsersService();

    User currentUser =
        await usersService.getUserWithUid(AuthService().currentUser?.uid ?? "");

    try {
      final resp = await http.get(url);
      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }
      List<Event> eventsAux = [];
      Map<String, dynamic> data = jsonDecode(resp.body);

      data.forEach((key, value) {
        final event = Event.fromRawJson(jsonEncode(value));
        if (currentUser.preferences
                .toSet()
                .intersection(event.tags.toSet())
                .isNotEmpty &&
            !event.hasFinished /* && currentUser.city == event.city*/) {
          eventsAux.add(event);
        }
      });
      eventsFound = eventsAux;
      return eventsAux;
    } catch (e) {
      throw Exception('Error getting events: $e');
    }
  }

  Future<void> addUserToEvent(Event event) async {
    String eventId = event.id;
    String activeUserId = AuthService().currentUser?.uid ?? "";
    if (activeUserId.isEmpty ||
        eventId.isEmpty ||
        event.users.contains(activeUserId)) {
      throw Exception(
          'Be sure to be logged, make sure that the event exists and check if you aren´t already part of the event');
    } else {
      event.users.add(activeUserId);
      final url = Uri.https(_baseUrl, 'Events/$eventId.json');

      try {
        final resp = await http.put(url, body: jsonEncode(event.toJson()));

        if (resp.statusCode != 200) {
          throw Exception('Error while trying to update the event');
        }
      } catch (e) {
        throw Exception('Error while trying to update the event');
      }
    }
  }
}
