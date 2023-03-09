import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class EventsService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  
  List<dynamic> _events = [];

  List<dynamic> get events => _events;

  void set setEvents(List<dynamic> inputEvents) {
    _events = inputEvents;
    notifyListeners();
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
  Future<void> getEvents() async {
    final url = Uri.https(_baseUrl, 'Events.json');
     try {

      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        return;
      }

      Map<String, dynamic> data = jsonDecode(resp.body);

      data.forEach((key, value) {
        final event = Event.fromRawJson(jsonEncode(value));
        _events.add(event);
      });

    } catch (e) {
      print('Error getting events: $e');
    }
  }

}
