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
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
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
                  Text(event.startDate.toString()),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(event.address),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('5/8 asistentes'),
                ],
              ),
              Spacer(),
              Container(
                  width: 150, height: 150, child: Image.network(event.image))
            ],
          )
        ],
      ),
    );
  }
}
