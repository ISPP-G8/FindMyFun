import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findmyfun/views/access/login_view.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  group('Widget testing Login screen', () {
    testWidgets('Succesful login test', (WidgetTester tester) async {
      const loginWidget = LoginView();
      await tester.pumpWidget(loginWidget);

      final emailFinder = find.byKey(Key('Email'));
      await tester.enterText(emailFinder, 'test@test.com');
      expect(find.text('test@test.com'), findsOneWidget);

      final nombreFinder = find.byKey(Key('Contraseña'));
      await tester.enterText(nombreFinder, 'test123');
      expect(find.text('test123'), findsOneWidget);
      
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('Por favor, introducir un valor válido'), findsNothing);
    });

    testWidgets('Failed login by empty email test', (WidgetTester tester) async {
      const loginWidget = LoginView();
      await tester.pumpWidget(loginWidget);

      final emailFinder = find.byKey(Key('Email'));
      await tester.enterText(emailFinder, '');
      expect(find.text('failed@test.com'), findsOneWidget);

      final nombreFinder = find.byKey(Key('Contraseña'));
      await tester.enterText(nombreFinder, 'contra12');
      expect(find.text('contra12'), findsOneWidget);
      
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('Por favor, introducir un valor válido'), findsOneWidget);
    });

    testWidgets('Failed login by empty password test', (WidgetTester tester) async {
      const loginWidget = LoginView();
      await tester.pumpWidget(loginWidget);

      final emailFinder = find.byKey(Key('Email'));
      await tester.enterText(emailFinder, 'failed@test.com');
      expect(find.text('failed@test.com'), findsOneWidget);

      final nombreFinder = find.byKey(Key('Contraseña'));
      await tester.enterText(nombreFinder, '');
      expect(find.text('contra12'), findsOneWidget);
      
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('Por favor, introducir un valor válido'), findsOneWidget);
    });

    testWidgets('Failed submit test', (WidgetTester tester) async {
      const loginWidget = LoginView();
      await tester.pumpWidget(loginWidget);

      final emailFinder = find.byKey(Key('Email'));
      await tester.enterText(emailFinder, 'failed@test.com');
      expect(find.text('failed@test.com'), findsOneWidget);

      final nombreFinder = find.byKey(Key('Contraseña'));
      await tester.enterText(nombreFinder, 'contra12');
      expect(find.text('contra12'), findsOneWidget);
      
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Contraseña'), findsOneWidget);
    });
  });
}