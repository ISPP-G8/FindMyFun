import 'package:findmyfun/screens/screens.dart';
import 'package:flutter/material.dart';

Map<String, Widget Function(BuildContext)> exportRoutes() {
  Map<String, Widget Function(BuildContext)> routes = {
    'login': (_) => const LoginView(),
    'register': (_) => const RegisterScreen(),
    'access': (_) => const AccessScreen(),
    'profile': (_) => const ProfileDetailsView(),
  };

  return routes;
}
