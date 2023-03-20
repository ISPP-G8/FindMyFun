import 'package:findmyfun/screens/screens.dart';
import 'package:findmyfun/views/event/event_chat_view.dart';
import 'package:findmyfun/views/event/event_details.dart';
import 'package:flutter/material.dart';
import '../views/views.dart';

Map<String, Widget Function(BuildContext)> exportRoutes() {
  Map<String, Widget Function(BuildContext)> routes = {
    'login': (_) => const LoginView(),
    'register': (_) => const RegisterScreen(),
    'access': (_) => const AccessScreen(),
    'profile': (_) => const ProfileDetailsView(),
    'preferences': (_) => const PreferencesView(),
    'main': (_) => const MainScreen(),
    'middle': (_) => const MiddleScreen(),
    'eventDetails': (_) => const EventDetailsView(),
    'chat': (_) => ChatScreen(),
  };

  return routes;
}
