import 'package:findmyfun/screens/screens.dart';
import 'package:flutter/material.dart';
import '../views/views.dart';

Map<String, Widget Function(BuildContext)> exportRoutes() {
  Map<String, Widget Function(BuildContext)> routes = {
    'login': (_) => const LoginView(),
    'register': (_) => const RegisterScreen(),
    'access': (_) => const AccessScreen(),
    'profile': (_) => const ProfileDetailsView(),
    'preferences':(_) => const PreferencesView(),
    'main': (_) => const MainScreen(),
    'middle': (_) => const MiddleScreen(),
  };

  return routes;
}
