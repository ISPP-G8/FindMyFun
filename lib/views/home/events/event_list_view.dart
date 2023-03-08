import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventListView extends StatelessWidget {
  const EventListView({super.key});

  @override
  Widget build(BuildContext context) {
    final eventsService = Provider.of<EventsService>(context);
    final events = eventsService.events;
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: ProjectColors.primary,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                  child: Text(
                'Tus eventos',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: size.height),
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (_, index) => _EventContainer(
                    event: events[index],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class _EventContainer extends StatelessWidget {
  final Event event;
  const _EventContainer({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(
                    event.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(event.startDate.toString().substring(0, 16)),
                  const SizedBox(height: 8, width: 200),
                  Row(children: [
                    Icon(Icons.location_pin),
                    Text(" " + event.address + ", " + event.city)
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(event.attendants + "/8 participantes")
                ],
              ),
              Spacer(),
              Container(
                  width: 120, height: 120, child: Image.network(event.image))
            ],
          )
        ],
      ),
    );
  }
}
