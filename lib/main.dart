import 'package:findmyfun/routes/app_routes.dart';
import 'package:findmyfun/services/messages_service.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PageViewService(),
        ),
        ChangeNotifierProvider(
          create: (_) => EventsService(),
        ),
        ChangeNotifierProvider(
          create: (_) => UsersService(),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesService(),
        ),
        ChangeNotifierProvider(
          create: (_) => EventPointsService(),
        ),
        ChangeNotifierProvider(
          create: (_) => MessagesService(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: exportRoutes(),
      initialRoute: 'middle',
      theme: AppTheme.lightTheme,
    );
  }
}
