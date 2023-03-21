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

  //POST AND UPDATE EVENT
  Future<void> saveEvent(EventPoint eventPoint, User currentUser) async {
    if (currentUser.isCompany == null || currentUser.isCompany == false) return;
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
}
