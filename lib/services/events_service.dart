import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class EventsService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  //POST AND UPDATE EVENT
  Future<void> saveEvent(Event event) async {
    final url = Uri.https(_baseUrl, 'Events/${event.id}.json');
    try {
      final resp = await http.put(url, body: jsonEncode(event.toJson()));
    } catch (e) {
      print('Error creating event: $e');
    }
  }
}
