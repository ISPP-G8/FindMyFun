import 'package:findmyfun/views/event/event_details%20admin.dart';
import 'package:findmyfun/views/event/event_map_view.dart';
import 'package:findmyfun/views/home/profile/profile_credentials_view.dart';
import 'package:findmyfun/views/home/profile/profile_details_admin.dart';
import 'package:findmyfun/views/home/profile/profile_edit_admin.dart';
import 'package:findmyfun/views/home/profile/profile_edit_view.dart';
import 'package:findmyfun/views/register/payment_view2.dart';
import 'package:findmyfun/views/register/register_view_plan.dart';
import 'package:findmyfun/views/register/register_view_user_plan.dart';
import 'package:flutter/material.dart';

import '../views/home/profile/eventcreator_profile_view.dart';
import '../views/views.dart';

Map<String, Widget Function(BuildContext)> exportRoutes() {
  Map<String, Widget Function(BuildContext)> routes = {
    'login': (_) => const LoginView(),
    'register': (_) => const RegisterScreen(),
    'access': (_) => const AccessScreen(),
    'users': (_) => const UsersListViewScreen(),
    'profile': (_) => const ProfileDetailsView(),
    'profileAdmin': (_) => const ProfileDetailsAdmin(),
    'settings': (_) => const SettingsView(),
    'preferences': (_) => const PreferencesView(),
    'main': (_) => const MainScreen(),
    'middle': (_) => const MiddleScreen(),
    'eventDetails': (_) => const EventDetailsView(),
    'eventDetailsAdmin': (_) => const EventDetailsAdmin(),
    'eventpointcreation': (_) => const EventPointCreationScreen(),
    'map': (_) => const EventMapView(),
    'chat': (_) => const ChatScreen(),
    'searchResulst': (_) => const EventSearchView(),
    'editProfile': (_) => const ProfileEditForm(),
    'editProfileAdmin': (_) => const ProfileEditAdmin(),
    'editCredentials': (_) => const ProfileCredentialsForm(),
    'eventpointsadmin': (_) => const EventPointsAdminView(),
    'events': (_) => const EventListViewAdmin(),
    'paymentBusiness': (_) => PaymentViewBusiness(),
    'paymentUser': (_) => PaymentViewUser(),
    'notifications': (_) => const NotificationView(),
    'creatorProfile': (_) => const EventCreatorProfileDetailsView(),
    'registerPlan': (_) => const RegisterViewPlan(),
    'registerUserPlan': (_) => const RegisterUserPlan(),
    'eventPointDetailsView': (_) => EventPointDetailsView(),
  };

  return routes;
}
