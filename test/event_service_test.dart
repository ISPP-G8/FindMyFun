// ignore: avoid_web_libraries_in_flutter

import 'package:findmyfun/services/events_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'event_service_test.mocks.dart';


class MockEventsService extends Mock implements EventsService {}

@GenerateMocks([MockEventsService])
void main() {
  late MockEventsService mockEventsService;
  
  setUpAll(() {
    mockEventsService = MockMockEventsService();
  });

  group('event service test', () {
    test('test getEvents', () async {      

      final model = Event();

      when(mockEventsService.getEvents()).thenAnswer((_) async {
        return model;
      });

      final res = await mockEventsService.getEvents();

      expect(res, isA<Event>());
      expect(res, model);
    });

    test('test fetchData throws Exception', () {
      when(mockEventsService.getEvents()).thenAnswer((_) async {
        throw Exception();
      });

      final res = mockEventsService.getEvents();

      expect(res, throwsException);
    });
  });

}
