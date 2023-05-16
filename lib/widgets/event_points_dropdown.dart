import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventPointsDropdown extends StatefulWidget {
  final List<Object>? selectedValues;
  final Function(List<Object>) onSelectionChanged;
  const EventPointsDropdown({
    Key? key,
    this.selectedValues,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<EventPointsDropdown> createState() => _EventPointsDropdown();
}

class _EventPointsDropdown extends State<EventPointsDropdown> {
  List<Object> selectedEventPoints = [];

  @override
  Widget build(BuildContext context) {
    final eventPointService = Provider.of<EventPointsService>(context);
    eventPointService.getEventPoints();
    List<EventPoint> eventPoints =
        eventPointService.eventPoints;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: const BoxDecoration(color: Colors.white),
      child: DropdownButton(
        items: eventPoints.map<DropdownMenuItem<String>>((EventPoint value) {
        return DropdownMenuItem<String>(
          value: "[${value.latitude},${value.longitude}]",
          child: Text(value.name),
        );
      }).toList(), 
        onChanged: (String? value) {
          setState(() {
            value = value!;
        });
        },
      ),
    );
  }
}
