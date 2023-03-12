import 'package:findmyfun/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:findmyfun/views/access/login_view.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  group('Unit testing Login screen', () {

    test('Sign in with valid email and password', () async {

      await AuthService().signInWithEmailAndPassword(email:'test@test.com', password:'test123');

      expect(Future.value(true), isTrue);
    });

    test('Sign in with valid email and invalid password', () async {

      await AuthService().signInWithEmailAndPassword(email:'test@test.com', password:'contra12');

      expect(Future.value(false), isTrue);
    });

    test('Sign in with invalid email or password', () async {

      await AuthService().signInWithEmailAndPassword(email:'mi@correo.com', password:'contra12');

      expect(Future.value(false), isTrue);
    });
  });
}
