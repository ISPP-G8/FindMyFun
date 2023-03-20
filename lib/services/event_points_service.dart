import 'dart:async';
import 'dart:convert';

import 'package:findmyfun/models/preferences.dart';
import 'package:findmyfun/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/event_point.dart';
import '../models/user.dart';
import 'users_service.dart';

class EventPointsService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  List<EventPoint> _eventPoints = [];

  List<EventPoint> get eventPoints => _eventPoints;

  set eventPoints(List<EventPoint> val) {
    _eventPoints = val;

    notifyListeners();
  }

  //POST AND UPDATE EVENT
  Future<void> saveEvent(EventPoint eventPoint) async {
    final url = Uri.https(_baseUrl, 'EventPoints/${eventPoint.id}.json');
    try {
      final resp = await http.put(url, body: jsonEncode(eventPoint.toJson()));
      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }
    } catch (e) {
      debugPrint('Error creating event point: $e');
    }
  }

  Future<void> getItems() async {
    final url = Uri.https(_baseUrl, 'EventPoints.json');

    try {
      final resp = await http.get(url);
      if (resp.statusCode != 200) return;

      Map<String, dynamic> data = jsonDecode(resp.body);

      List<EventPoint> aux = [];

      data.forEach((key, value) {
        final eventPoint = EventPoint.fromJson(value);
        aux.add(eventPoint);
      });
      eventPoints = aux;
    } catch (e) {
      print('Error al obtener los puntos de eventos: $e');
    }
  }
}
