import 'package:findmyfun/screens/screens.dart';
import 'package:flutter/material.dart';

import '../views/views.dart';

Map<String, Widget Function(BuildContext)> exportRoutes() {
  Map<String, Widget Function(BuildContext)> routes = {
    'login': (_) => const LoginView(),
    'register': (_) => const RegisterScreen(),
    'access': (_) => const AccessScreen(),
  };

<<<<<<< HEAD
  return routes;
=======
    'login':(_) => const LoginView(),
    'register':(_) => const RegisterScreen(),
    'access':(_) => const AccessScreen(),
    'preferences':(_) => const PreferencesView(),
   };

   return routes;
>>>>>>> origin/Vista-de-preferencias-frontend
}
