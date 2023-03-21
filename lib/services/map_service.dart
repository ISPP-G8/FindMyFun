import 'dart:async';
import 'package:findmyfun/services/services.dart';
import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService extends ChangeNotifier {
  EventsService eventsService = EventsService();
  EventPointsService eventPointsService = EventPointsService();

  // GET ALL MARKERS
  Future<List<Marker>> getMarkers(isEventDetailsVisible) async {
    List<Marker> markers = [];

    List<Event> events = await eventsService.getEvents();
    List<EventPoint> eventPoints = await eventPointsService.getEventPoints();

    for (var event in events) {
      markers.add(Marker(
          markerId: MarkerId(event.id),
          position: LatLng(event.latitude, event.longitude),
        )
      );
    }

    for (var eventPoint in eventPoints) {
      markers.add(Marker(
          markerId: MarkerId(eventPoint.id),
          position: LatLng(eventPoint.latitude, eventPoint.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        )
      );
    }

    return markers;
  }
}
