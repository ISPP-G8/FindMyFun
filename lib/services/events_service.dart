import 'dart:async';
import 'dart:convert';

import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/services/important_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EventsService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-dev-default-rtdb.firebaseio.com';
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
      // ignore: unused_local_variable
      final resp = await http.delete(url);
    } catch (e) {
      debugPrint('Error al eliminar el evento: $e');
    }
  }

  Future<void> deleteEventAdmin(String eventId, BuildContext context) async {
    final url = Uri.https(_baseUrl, 'Events/$eventId.json');
    try {
      // ignore: unused_local_variable
      final resp = await http.delete(url);
      Navigator.pushNamed(context, 'events');
    } catch (e) {
      debugPrint('Error al eliminar el evento: $e');
    }
  }

  Future<void> deleteUserFromEvent(String eventId, String userId) async {
    final url = Uri.https(_baseUrl, 'Events/$eventId/users/$userId.json');
    try {
      final resp = await http.delete(url);
      debugPrint(resp.body);
    } catch (e) {
      debugPrint('Error al eliminar el usuario del evento: $e');
    }
  }

  //POST AND UPDATE EVENT
  Future<void> saveEvent(BuildContext context, Event event) async {
    final usersService = Provider.of<UsersService>(context, listen: false);
    if (!usersService.currentUser!.subscription.canCreateEvents) return;
    final url = Uri.https(_baseUrl, 'Events/${event.id}.json');
    print('id del evento: ${event.id}');
    try {
      // ignore: unused_local_variable
      final resp = await http.put(url, body: jsonEncode(event.toJson()));
    } catch (e) {
      debugPrint('Error creating event: $e');
    }
  }

  //READ EVENT
  Future<List<Event>> getEvents() async {
    final url = Uri.https(_baseUrl, 'Events.json');
    try {
      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }
      List<Event> eventsAux = [];
      Map<String, dynamic> data = jsonDecode(resp.body);

      data.forEach((key, value) {
        try {
          final event = Event.fromRawJson(jsonEncode(value));
          eventsAux.add(event);
        } catch (e) {
          debugPrint('Error parsing event: $e');
        }
      });

      events = eventsAux;
      return eventsAux;
    } catch (e) {
      throw Exception('Error getting events: $e');
    }
  }

  //GET EVENT OF LOGGED USER
  Future<List<Event>> getEventsOfLoggedUser() async {
    final url = Uri.https(_baseUrl, 'Events.json');
    final currentUser = AuthService().currentUser?.uid ?? "";

    try {
      final resp = await http.get(url);

      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }
      List<Event> eventsAux = [];
      Map<String, dynamic> data = jsonDecode(resp.body);

      data.forEach((key, value) {
        try {
          final event = Event.fromRawJson(jsonEncode(value));
          if (event.users.contains(currentUser) &&
              DateTime.now().isBefore(event.startDate)) {
            eventsAux.add(event);
          }
        } catch (e) {
          debugPrint('Error parsing event: $e');
        }
      });

      events = eventsAux;
      return eventsAux;
    } catch (e) {
      throw Exception('Error getting events: $e');
    }
  }

  //FIND EVENTS THAT SHARE TAGS WITH USER, ARE NOT FULL, ARE VISIBLE, ARE NOT FINISHED AND USER IS NOT IN
  Future<List<Event>> findEvents() async {
    final url = Uri.https(_baseUrl, 'Events.json');
    final UsersService usersService = UsersService();

    User currentUser = await usersService.getCurrentUserWithUid();

    try {
      final resp = await http.get(url);
      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }
      List<Event> eventsAux = [];
      Map<String, dynamic> data = jsonDecode(resp.body);

      data.forEach((key, value) {
        try {
          final event = Event.fromRawJson(jsonEncode(value));
          if (currentUser.preferences
                  .toSet()
                  .intersection(event.tags.toSet())
                  .isNotEmpty &&
              !event.hasFinished &&
              event.isVisible &&
              !event.isFull &&
              !event.users.contains(currentUser.id)) {
            eventsAux.add(event);
          }
        } catch (e) {
          debugPrint('Error parsing event: $e');
        }
      });
      eventsFound = eventsAux;
      return eventsAux;
    } catch (e) {
      throw Exception('Error getting events: $e');
    }
  }

  Future<void> addUserToEvent(BuildContext context, Event event) async {
    String eventId = event.id;
    String activeUserId = AuthService().currentUser?.uid ?? "";
    final usersService = Provider.of<UsersService>(context, listen: false);
    User activeUser = await usersService.getCurrentUserWithUid();

    if (event.isFull) {
      throw Exception('Error: Event is full');
    }
    if (event.users.contains(activeUserId)) {
      throw Exception('Error: User is already in event');
    }
    if (activeUser.subscription.type == SubscriptionType.company) {
      throw Exception('Error: Company users cannot join events');
    }

    /*final notificationsService =
        Provider.of<ImportantNotificationService>(context, listen: true);*/
    if (activeUserId.isEmpty ||
        eventId.isEmpty ||
        event.hasFinished ||
        event.users.contains(activeUserId)) {
      throw Exception(
          'Asegúrate de haber iniciado sesión, de que el evento existe y está activo no estás dentro de él');
    } else {
      event.users.add(activeUserId);
      final currentUser = usersService.currentUser;
      ImportantNotification notificationUsuarioEntra = ImportantNotification(
          userId: activeUserId,
          date: DateTime.now(),
          info: "Te has unido correctamente al evento ${event.name}");
      ImportantNotification notificationDuenoEvento = ImportantNotification(
          userId: event.creator,
          date: DateTime.now(),
          info: "${currentUser!.name} se ha unido al evento ${event.name}");
      ImportantNotificationService()
          .saveNotification(context, notificationDuenoEvento, event.creator);
      ImportantNotificationService()
          .saveNotification(context, notificationUsuarioEntra, activeUserId);
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

  Future<List<Event>> searchForEvents(String text) async {
    try {
      final url = Uri.https(_baseUrl, 'Events.json');
      final resp = await http.get(url);
      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }
      List<String> words = text.split(" ");
      List<Event> eventsAux = [];
      Map<String, dynamic> data = jsonDecode(resp.body);

      data.forEach((key, value) {
        try {
          final event = Event.fromRawJson(jsonEncode(value));
          if (!event.hasFinished) {
            int i = 0;
            for (String word in words) {
              word = removeDiacritics(word).toLowerCase();
              if ((removeDiacritics(event.address)
                          .toLowerCase()
                          .contains(word) ||
                      removeDiacritics(event.city)
                          .toLowerCase()
                          .contains(word) ||
                      removeDiacritics(event.description)
                          .toLowerCase()
                          .contains(word) ||
                      removeDiacritics(event.name)
                          .toLowerCase()
                          .contains(word)) &&
                  !event.isFull) {
                i = i + 1;
              }
              if (i == words.length) {
                eventsAux.add(event);
              }
            }
          }
        } catch (e) {
          //Exception('Se ha producido un error buscando eventos: $e');
        }
      });
      if (eventsAux.isNotEmpty) {
        eventsFound = eventsAux;
        return eventsFound;
      } else {
        eventsFound = [];
        for (Event e in events) {
          if (!e.hasFinished && !e.isFull) {
            eventsFound.add(e);
          }
        }
        return eventsFound;
      }
    } catch (e) {
      eventsFound = [];
      throw Exception('Se ha producido un error al obtener eventos: $e');
    }
    // }
  }

  String removeDiacritics(String str) {
    var withDia =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia =
        'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }
  //READ USERS EVENTS

  Future<List<String>> getUsersFromEvent(Event event) async {
    String eventId = event.id;
    final url = Uri.https(_baseUrl, 'Events/$eventId.json');

    try {
      List<String> idAux = [];
      final resp = await http.get(url);
      if (resp.statusCode != 200) {
        throw Exception('Error in response');
      }
      Map<String, dynamic> data = jsonDecode(resp.body);

      for (var a in data["users"]) {
        idAux.add(a.toString());
      }
      return idAux;
    } catch (e) {
      throw Exception('Error getting ids');
    }
  }

  Future<List<String>> getNameFromId(List<String> ids) async {
    try {
      List<String> usersAux = [];
      for (var id in ids) {
        final resp = await http.get(Uri.https(_baseUrl, 'Users/$id.json'));

        Map<String, dynamic> data = jsonDecode(resp.body);
        usersAux.add(data["username"]);
      }
      // ignore: avoid_print
      print(usersAux);
      return usersAux;
    } catch (e) {
      throw Exception('Error getting users');
    }
  }

  Future<User> getEventCreator(BuildContext context, Event event) async {
    final userService = Provider.of<UsersService>(context, listen: false);
    User eventCreator = await userService.getUserWithUid(event.creator);
    return eventCreator;
  }
}
