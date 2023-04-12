import 'package:findmyfun/screens/access_screen.dart';
import 'package:findmyfun/screens/main_screen.dart';
import 'package:findmyfun/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MiddleScreen extends StatefulWidget {
  const MiddleScreen({Key? key}) : super(key: key);

  @override
  State<MiddleScreen> createState() => _MiddleScreenState();
}

class _MiddleScreenState extends State<MiddleScreen> {
  User? user;

  @override
  Widget build(BuildContext context) {
    user = AuthService().currentUser;
    final userService = Provider.of<UsersService>(context);

    // TODO: asignar usuario en usuariosService

    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (user == null || !snapshot.hasData) {
          return const AccessScreen();
        }

        try {
          user = AuthService().currentUser;
          userService.getCurrentUserWithUid();

          return const MainScreen();
        } catch (e) {
          return const AccessScreen();
        }
      },
    );
  }
}
