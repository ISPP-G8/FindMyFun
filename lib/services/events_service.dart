import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class EventsService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  
  Future<void> updateEvent(Event event) async {
    final url = Uri.https(_baseUrl, 'Events/${event.id}.json');
    var eventCreator = event.creator;
    var getCreator = '';
    try {
      final get = await http.get(url);
      final jsonResponse = json.decode(get.body);
      getCreator = jsonResponse['creator'];
    } catch (e) {
      print('Error creating event: $e');
    }
    if(getCreator==eventCreator) {
      try {
        final put = await http.put(url, body: jsonEncode(event.toJson()));
      } catch (e) {
        print('Error creating event: $e');
      }
    }
  }
}