import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventSearchView extends StatelessWidget {
  const EventSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final eventsService = Provider.of<EventsService>(context);
    // TODO: Cambiar los eventos que se muestran
    // eventsService.findEvents();
    final events = eventsService.events;
    final size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ProjectColors.primary,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                  child: Text(
                'BÚSQUEDA',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: size.height),
                child: RefreshIndicator(
                  onRefresh: () async => await eventsService.getEvents(),
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (_, index) => EventContainer(
                      event: events[index],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
