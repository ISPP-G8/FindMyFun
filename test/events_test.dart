import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/models/user.dart';
import 'package:findmyfun/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:findmyfun/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:findmyfun/routes/app_routes.dart';

import 'package:findmyfun/services/events_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppState());
  test('One user joins an event', () {
    // Creation of the event´s creator
    final creatorUser = User(
        id: "creatorTest1",
        image:
            "https://www.google.com/imgres?imgurl=https%3A%2F%2Fstatic.wikia.nocookie.net%2Fcaracteres-fanon%2Fimages%2F1%2F17%2FDivino_Creador.jpg%2Frevision%2Flatest%3Fcb%3D20160628192854%26path-prefix%3Des&imgrefurl=https%3A%2F%2Fcaracteres-fanon.fandom.com%2Fes%2Fwiki%2FDivino_Creador&tbnid=L8eVaiTLr9UwsM&vet=12ahUKEwiGuardhNL9AhXWtycCHZD8AxIQMygEegUIARDmAQ..i&docid=Sg-Du4JB5Cau0M&w=1600&h=900&q=creador&hl=es&client=firefox-b-d&ved=2ahUKEwiGuardhNL9AhXWtycCHZD8AxIQMygEegUIARDmAQ",
        name: "creatorTest1",
        surname: "creatorTest1",
        username: "creatortest1",
        city: "creatorTest1",
        email: "creatortest1@test1.com",
        preferences: []);
    // Creation of an event to test
    final event = Event(
        address: 'test1',
        city: 'test1',
        country: 'test1',
        description: 'This event is only for testing purposes',
        finished: false,
        id: 'test1',
        image:
            'https://www.google.com/imgres?imgurl=https%3A%2F%2Fwww.protocoloimep.com%2Fapp%2Fuploads%2F2018%2F11%2Fque-es-un-evento.jpg&imgrefurl=https%3A%2F%2Fwww.protocoloimep.com%2Farticulos%2Fque-es-un-evento-y-clasificacion%2F&tbnid=18bKl4dNst8pwM&vet=12ahUKEwidmqHUg9L9AhWBtScCHa5bBSMQMygAegUIARDeAQ..i&docid=WYHmCIY7oB-YrM&w=1024&h=500&q=evento&client=firefox-b-d&ved=2ahUKEwidmqHUg9L9AhWBtScCHa5bBSMQMygAegUIARDeAQ',
        name: 'Event test 1',
        startDate: DateTime.now(),
        tags: [],
        users: [creatorUser.id]);
    int initialNumberOfUsers = event.users.length;
    // Creation of an user to test
    final testUser = User(
        id: "test1",
        image:
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fes.dreamstime.com%2Ffoto-de-archivo-persona-feliz-en-el-campo-image42388021&psig=AOvVaw1MSO-DFzC-u5H17VRNg93G&ust=1678554113861000&source=images&cd=vfe&ved=0CA8QjRxqFwoTCNDS8r7r0f0CFQAAAAAdAAAAABAQ",
        name: "test1",
        surname: "test1",
        username: "test1",
        city: "test1",
        email: "test1@test1.com",
        preferences: []);
    void testLogAndAddUser() async {
      await AuthService()
          .signInWithEmailAndPassword(email: testUser.email, password: 'asd');
      await EventsService().addUserToEvent(event);
    }

    testLogAndAddUser();
    expect(event.users.length, initialNumberOfUsers + 1);
  });
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
      initialRoute: 'access',
    );
  }
}
