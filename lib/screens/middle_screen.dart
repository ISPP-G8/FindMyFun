import 'package:findmyfun/screens/access_screen.dart';
import 'package:findmyfun/screens/main_screen.dart';
import 'package:findmyfun/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

    // TODO: asignar usuario en usuariosService

    return StreamBuilder(
      stream: AuthService().authStateChanges,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (user == null || !snapshot.hasData) {
          return AccessScreen();
        }

        try {
          user = AuthService().currentUser;
          print(user?.email);

          return MainScreen();
        } catch (e) {
          return AccessScreen();
        }
      },
    );
  }
}
