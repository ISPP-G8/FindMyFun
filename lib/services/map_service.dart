import 'dart:async';
import 'dart:convert';
import 'package:findmyfun/services/services.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class MapService extends ChangeNotifier {
  EventsService eventsService = EventsService();
  EventPointsService eventPointsService = EventPointsService();
  AuthService authService = AuthService();
  String _selecteddirection = '';

  String get selectedDirection => _selecteddirection;

  set selectedDirection(String val) {
    _selecteddirection = val;
    notifyListeners();
  }

  // GET ALL MARKERS
  Future<List<Point>> getMarkers() async {
    List<Point> markers = [];

    String currentUser = AuthService().currentUser?.uid ?? "";
    List<Event> events = await eventsService.getEvents();
    List<EventPoint> eventPoints = await eventPointsService.getEventPoints();

    for (var event in events) {
      markers.add(Point(
          event: event,
          marker: Marker(
            markerId: MarkerId(event.id),
            position: LatLng(event.latitude, event.longitude),
            icon: event.users.contains(currentUser)
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueMagenta)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
          )));
    }

    for (var eventPoint in eventPoints) {
      markers.add(Point(
          event: eventPoint,
          marker: Marker(
            markerId: MarkerId(eventPoint.id),
            position: LatLng(eventPoint.latitude, eventPoint.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet),
          )));
    }

    return markers;
  }

  // Get direction by LatLng
  Future<void> getDirectionByLatLng(LatLng selectedLocation) async {
    const baseUrl = 'api.mapbox.com';
    final Map<String, dynamic> queryParam = {
      'access_token':
          'pk.eyJ1IjoicGVyaWtlIiwiYSI6ImNsZ2Y2aWticjByMHAzbW1mYmN0cmpleXUifQ.CfnDK4Flnu4ghv3HUnLkZg'
    };
    final url = Uri.https(
        baseUrl,
        '/geocoding/v5/mapbox.places/${selectedLocation.longitude},${selectedLocation.latitude}.json',
        queryParam);
    final resp = await http.get(url);
    Map<String, dynamic> decodedResponse = jsonDecode(resp.body);
    selectedDirection = decodedResponse["features"][0]["place_name"];
  }
}
