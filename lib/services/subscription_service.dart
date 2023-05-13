import 'dart:convert';
//import 'dart:html';

import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:findmyfun/helpers/helpers.dart';

class SubscriptionService extends ChangeNotifier {
  final String _baseUrl = Globals.getBaseUrl();
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

  Future<User> resetSubscription(User user) async {
    user.subscription.numEventsCreatedThisMonth = 0;
    user.subscription.lastReset = DateTime.now();

    // Add a notification to the user
    ImportantNotification notification = ImportantNotification(
        userId: user.id,
        date: DateTime.now(),
        info: "Se ha reiniciado su contador de eventos creados.");
    user.notifications.add(notification);

    await usersService.addItem(user);

    return user;
  }

  Future<User> changePlanToFree(User user, {bool expired = false}) async {
    // Set all the event points to invisible if user was a company
    if (user.subscription.type == SubscriptionType.company) {
      await eventPointsService.setUsersEventPointsToInvisible(user);
    }

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

    await usersService.addItem(user);

    return user;
  }

  Future<User> changePlanToPremium(User user) async {
    // Set all the event points to invisible if user was a company
    if (user.subscription.type == SubscriptionType.company) {
      await eventPointsService.setUsersEventPointsToInvisible(user);
    }

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

    // Set all the event points to visible if user is now a company
    if (user.subscription.type == SubscriptionType.company) {
      await eventPointsService.setUsersEventPointsToVisible(user);
    }

    await usersService.addItem(user);

    return user;
  }

  Future<User> checkSubscriptionValidity(User user) async {
    if (user.subscription.isExpired) {
      user = await changePlanToFree(user, expired: true);
    } else {
      if (user.subscription.needsReset) {
        user = await resetSubscription(user);
      }

      if (user.subscription.isAboutToExpire) {
        bool yaExiste = false;
        for (var i in user.notifications) {
          if (i!.info == "Le quedan 5 días o menos de suscripción") {
            yaExiste = true;
          }
        }
        if (!yaExiste) {
          ImportantNotification notification = ImportantNotification(
              userId: user.id,
              date: DateTime.now(),
              info: "Le quedan 5 días o menos de suscripción");
          user.notifications.add(notification);
          await usersService.addItem(user);
        }
      }
    }
    return user;
  }
}
