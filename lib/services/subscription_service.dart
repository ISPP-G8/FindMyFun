import 'dart:convert';
//import 'dart:html';

import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SubscriptionService extends ChangeNotifier {
  final String _baseUrl = 'findmyfun-c0acc-default-rtdb.firebaseio.com';
  final UsersService usersService = UsersService();
  final EventPointsService eventPointsService = EventPointsService();
  final currentAuthUser = AuthService().currentUser;

  //UPDATE PROFILE
  Future<bool> updateEventCount(BuildContext context, String userId) async {
    final usersService = Provider.of<UsersService>(context, listen: false);
    final currentUser = usersService.currentUser;
    currentUser!.subscription.numEventsCreatedThisMonth += 1;
    final url = Uri.https(_baseUrl, 'Users/$userId.json');
    try {
      // ignore: unused_local_variable
      final resp = await http.put(url, body: jsonEncode(currentUser));

      if (resp.statusCode != 200) return false;
      return true;
    } catch (e) {
      debugPrint('Error editing profile: $e');
      return false;
    }
  }

  Future<User> resetSubscription(User user) {
    user.subscription.numEventsCreatedThisMonth = 0;
    user.subscription.lastReset = DateTime.now();

    // Add a notification to the user
    ImportantNotification notification = ImportantNotification(
        userId: user.id,
        date: DateTime.now(),
        info: "Se ha reiniciado su contador de eventos creados.");
    user.notifications.add(notification);

    usersService.addItem(user);

    return Future.value(user);
  }

  Future<User> changePlanToFree(User user, {bool expired = false}) async {
    user.subscription.type = SubscriptionType.free;
    user.subscription.numEventsCreatedThisMonth = 0;
    user.subscription.validUntil = null;
    user.subscription.lastReset = DateTime.now();

    if (expired) {
      // Add a notification to the user
      ImportantNotification notification = ImportantNotification(
          userId: user.id,
          date: DateTime.now(),
          info:
              "Tu suscripción ha terminado y se ha cambiado automáticamente al plan gratuito.");
      user.notifications.add(notification);
    } else {
      // Add a notification to the user
      ImportantNotification notification = ImportantNotification(
          userId: user.id,
          date: DateTime.now(),
          info: "Su subcripción se acaba de cambiar al plan gratuito.");
      user.notifications.add(notification);
    }

    // Set all the event points to invisible
    eventPointsService.setUsersEventPointsToInvisible(user);

    await usersService.addItem(user);

    return user;
  }

  Future<User> changePlanToPremium(User user) async {
    user.subscription.type = SubscriptionType.premium;
    user.subscription.numEventsCreatedThisMonth = 0;
    user.subscription.validUntil = DateTime.now().add(const Duration(days: 30));
    user.subscription.lastReset = DateTime.now();

    // Add a notification to the user
    ImportantNotification notification = ImportantNotification(
        userId: user.id,
        date: DateTime.now(),
        info: "Su subcripción se acaba de cambiar al plan premium.");
    user.notifications.add(notification);

    // Set all the event points to invisible
    eventPointsService.setUsersEventPointsToInvisible(user);

    await usersService.addItem(user);

    return user;
  }

  Future<User> changePlanToCompany(User user) async {
    user.subscription.type = SubscriptionType.company;
    user.subscription.numEventsCreatedThisMonth = 0;
    user.subscription.validUntil = DateTime.now().add(const Duration(days: 30));
    user.subscription.lastReset = DateTime.now();

    // Add a notification to the user
    ImportantNotification notification = ImportantNotification(
        userId: user.id,
        date: DateTime.now(),
        info: "Su subcripción se acaba de cambiar al plan empresa.");
    user.notifications.add(notification);

    // Set all the event points to visible
    eventPointsService.setUsersEventPointsToVisible(user);

    await usersService.addItem(user);

    return user;
  }

  Future<User> checkSubscriptionValidity(User user) async {
    if (user.subscription.isExpired) {
      User newUser = await changePlanToFree(user, expired: true);
      return newUser;
    } else if (user.subscription.needsReset) {
      User newUser = await resetSubscription(user);
      return newUser;
    }
    return user;
  }
}
