import 'dart:async';
import 'dart:convert';

import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/models/preferences.dart';
import 'package:findmyfun/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/event_point.dart';
import '../models/user.dart';
import 'users_service.dart';

class EventPointsService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';

  //POST AND UPDATE EVENT POINT
  Future<void> saveEventPoint(EventPoint eventPoint) async {
    final url = Uri.https(_baseUrl, 'EventPoints/${eventPoint.id}.json');
    try {
      final resp = await http.put(url, body: jsonEncode(eventPoint.toJson()));
      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }
    } catch (e) {
      throw Exception('Error creating event point: $e');
    }
  }

  // DELETE EVENT POINT
  Future<void> deleteEventPoint(String eventPointId) async {
    final url = Uri.https(_baseUrl, 'EventPoints/$eventPointId.json');
    try {
      final resp = await http.delete(url);
      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }
    } catch (e) {
      throw Exception('Error al eliminar el punto de evento: $e');
    }
  }

  // GET ALL EVENT POINTS
  Future<List<EventPoint>> getEventPoints() async {
    final url = Uri.https(_baseUrl, 'EventPoints.json');
    try {
      final resp = await http.get(url);
      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }

      final Map<String, dynamic> eventPointsMap = jsonDecode(resp.body);

      final List<EventPoint> eventPoints = [];
      eventPointsMap.forEach((key, value) {
        final eventPoint = EventPoint.fromJson(value);
        eventPoint.id = key;
        eventPoints.add(eventPoint);
      });

      return eventPoints;

    } catch (e) {
      throw Exception('Error getting event points: $e');
    }
  }
}
