import 'package:findmyfun/views/event/event_map_view.dart';
import 'package:findmyfun/views/home/profile/profile_credentials_view.dart';
import 'package:findmyfun/views/home/profile/profile_edit_view.dart';
import 'package:findmyfun/views/register/payment_view2.dart';
import 'package:flutter/material.dart';

import '../views/views.dart';

Map<String, Widget Function(BuildContext)> exportRoutes() {
  Map<String, Widget Function(BuildContext)> routes = {
    'login': (_) => const LoginView(),
    'register': (_) => const RegisterScreen(),
    'access': (_) => const AccessScreen(),
    'users': (_) => const UsersListViewScreen(),
    'profile': (_) => const ProfileDetailsView(),
    'preferences': (_) => const PreferencesView(),
    'main': (_) => const MainScreen(),
    'middle': (_) => const MiddleScreen(),
    'eventDetails': (_) => const EventDetailsView(),
    'eventpointcreation': (_) => const EventPointCreationScreen(),
    'map': (_) => const EventMapView(),
    'chat': (_) => const ChatScreen(),
    'searchResulst': (_) => const EventSearchView(),
    'editProfile': (_) => const ProfileEditForm(),
    'editCredentials': (_) => const ProfileCredentialsForm(),
    'eventpointsadmin': (_) => const EventPointsAdminView(),
    'events': (_) => const EventListViewAdmin(),
    //'paymentBusiness': (_) => const PaymentViewBusiness(),
    'paymentUser': (_) => const PaymentViewUser()
  };

  return routes;
}
