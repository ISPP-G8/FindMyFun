import 'package:findmyfun/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:findmyfun/models/event.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../services/services.dart';

class EventCreator extends StatefulWidget {
  final String creatorUsername;
  final Event event;
  const EventCreator(
      {super.key, required this.creatorUsername, required this.event});

  @override
  State<EventCreator> createState() => _EventCreator();
}

class _EventCreator extends State<EventCreator> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text(
          widget.creatorUsername,
          style: const TextStyle(
            color: Color(0xff545454),
            fontWeight: FontWeight.w500,
          ),
        ),
        CustomButton(
          text: 'Visitar perfil',
          width: 100,
          onTap: () async {
            final eventsService =
                Provider.of<EventsService>(context, listen: false);
            User eventCreator =
                await eventsService.getEventCreator(context, widget.event);

            Navigator.pushNamed(context, 'creatorProfile',
                arguments: eventCreator);
          },
        ),
      ]),
    );
  }
}