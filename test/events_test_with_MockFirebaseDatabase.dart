import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';

class EventRepository {
  EventRepository(this.firebaseDatabase);
  FirebaseDatabase firebaseDatabase;

  Future<String?> getEventName(String eventId) async {
    final eventNameReference =
        firebaseDatabase.ref().child('events').child(eventId).child('name');
    final databaseEvent = await eventNameReference.once();
    return databaseEvent.snapshot.value as String?;
  }

  Future<Map<String, dynamic>?> getEvent(String eventId) async {
    final eventNode = firebaseDatabase.ref().child('events/$eventId');
    final databaseEvent = await eventNode.once();
    return databaseEvent.snapshot.value as Map<String, dynamic>?;
  }
}

Future<void> main() async {
  FirebaseDatabase firebaseDatabase;
  late EventRepository eventRepository;
  // Put fake data
  const eventId = 'eventId';
  const eventName = 'ETSII';
  const fakeData = {
  "-NQBxSpoVmLGfXRNZ4Tp": {
    "address": "Reina Mercedes s/n",
    "city": "Sevilla",
    "country": "España",
    "description": "Universidad de Sevilla",
    "finished": true,
    "id": "b1205e70-bf79-11ed-86f4-f9284f243382",
    "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/5/5b/ETSI_Inform%C3%A1tica_Sevilla_y_DrupalCamp_Spain_2011.jpg/360px-ETSI_Inform%C3%A1tica_Sevilla_y_DrupalCamp_Spain_2011.jpg",
    "name": "ETSII",
    "startDate": "2012-04-23T18:25:43.511Z",
    "tags": [
      "educacion",
      "publico"
    ],
    "users": [
      "Pepe"
    ]
}
  };
  MockFirebaseDatabase.instance.ref().set(fakeData);
  setUp(() {
    firebaseDatabase = MockFirebaseDatabase.instance;
    eventRepository = EventRepository(firebaseDatabase);
  });
  
  test('Should get eventName ...', () async {
    final eventNameFromFakeDatabase = await eventRepository.getEventName(eventId);
    expect(eventNameFromFakeDatabase, equals(eventName));
  });

  test('Should get event ...', () async {
    final eventNameFromFakeDatabase = await eventRepository.getEvent(eventId);
    expect(
      eventNameFromFakeDatabase,
      equals({
        'name': eventName,
      }),
    );
  });
}