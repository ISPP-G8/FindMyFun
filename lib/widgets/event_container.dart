import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';
import '../themes/themes.dart';
import 'widgets.dart';

class EventContainer extends StatelessWidget {
  final Event event;
  const EventContainer({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
          color: ProjectColors.secondary,
          boxShadow: [
            BoxShadow(color: Colors.black54, spreadRadius: 1, blurRadius: 7)
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(
                    event.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(DateFormat('yyyy-MM-dd HH:mm').format(event.startDate)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(event.address),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${event.users.length} asistente/s'),
                ],
              ),
              Spacer(),
              Container(
                  width: 150, height: 150, child: Image.network(event.image))
            ],
          ),
          CustomButton(
            text: 'Detalles',
            onTap: () =>
                Navigator.pushNamed(context, 'eventDetails', arguments: event),
          ),
        ],
      ),
    );
  }
}
