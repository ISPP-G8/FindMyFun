import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:findmyfun/models/user.dart';
import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/main.dart';
import 'package:findmyfun/services/services.dart';

void main() {
  test('One user joins an test', () async {
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
    void testLogAndAddUser() async {
      runApp(const AppState());
      await AuthService().signInWithEmailAndPassword(
          email: 'test@test.com', password: 'test123');
      await EventsService().addUserToEvent(event);
    }

    testLogAndAddUser();
    expect(event.users.length, initialNumberOfUsers + 1);
  });
}
