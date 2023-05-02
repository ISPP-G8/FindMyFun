import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class EventPointsService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-dev-default-rtdb.firebaseio.com';
  List<EventPoint> _eventPoints = [];

  List<EventPoint> get eventPoints => _eventPoints;

  set eventPoints(List<EventPoint> val) {
    _eventPoints = val;

    notifyListeners();
  }

  //POST AND UPDATE EVENT POINT
  Future<void> saveEventPoint(EventPoint eventPoint, User currentUser) async {
    if (currentUser.subscription.type != SubscriptionType.company) return;
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

  Future<void> getEventPointsAdmin(User currentUser) async {
    if (currentUser.isAdmin == false || currentUser.isAdmin == null) return;
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
      // ignore: avoid_print
      print('Error al obtener los puntos de eventos: $e');
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

      final Map<String, dynamic> data = jsonDecode(resp.body);

      final List<EventPoint> eventPoints = [];
      data.forEach((key, value) {
        try {
          final eventPoint = EventPoint.fromJson(value);
          eventPoints.add(eventPoint);
        } catch (e) {
          debugPrint('Error parsing event point: $e');
        }
      });

      return eventPoints;
    } catch (e) {
      throw Exception('Error getting event points: $e');
    }
  }
}
