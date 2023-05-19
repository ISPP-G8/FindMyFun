import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/services.dart';
import 'package:flutter/material.dart';

class EventPointsDropdown extends StatefulWidget {
  final Object? selectedValue;
  final Function(String) onSelectionChanged;
  const EventPointsDropdown({
    Key? key,
    this.selectedValue,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<EventPointsDropdown> createState() => _EventPointsDropdown();
}

class _EventPointsDropdown extends State<EventPointsDropdown> {
  List<Object> selectedEventPoints = [];

  late Future eventsPoints;

  EventPointsService eventsPointService = EventPointsService();

  @override
  void initState() {
    super.initState();
    eventsPoints = eventsPointService.getEventPoints();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: eventsPoints,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: const BoxDecoration(color: Colors.white),
            child: DropdownButton<String?>(
              value:
                  "${snapshot.data.first.latitude},${snapshot.data.first.longitude}",
              items: snapshot.data
                  .map<DropdownMenuItem<String?>>((EventPoint value) {
                return DropdownMenuItem<String?>(
                  value: "${value.latitude},${value.longitude}",
                  child: Text(value.name),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  value = value!;
                  widget.onSelectionChanged(value!);
                });
              },
            ),
          );
        } else {
          return Column(children: const [
            SizedBox(height: 100),
            Center(child: CircularProgressIndicator())
          ]);
        }
      },
    );
  }
}
