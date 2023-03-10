import 'package:findmyfun/screens/screens.dart';
import 'package:findmyfun/views/views.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> exportRoutes() {
  Map<String, Widget Function(BuildContext)> routes = {
    'login': (_) => const LoginView(),
    'register': (_) => const RegisterScreen(),
    'access': (_) => const AccessScreen(),
    'Update': (_) => const UpdateEventView()
  };

  return routes;
}
