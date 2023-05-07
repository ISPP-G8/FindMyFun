import 'package:auto_size_text/auto_size_text.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';

class EventListView extends StatefulWidget {
  const EventListView({super.key});

  @override
  State<StatefulWidget> createState() => _EventListView();
}

class _EventListView extends State<EventListView> {
  late Future eventsFuture;

  @override
  void initState() {
    super.initState();

    eventsFuture = _getEvents();
  }

  _getEvents() async {
    EventsService eventsService = EventsService();
    return await eventsService.getEventsOfLoggedUser();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: ProjectColors.primary,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 0.005),
              const AdPlanLoader(),
              const Center(
                  child: AutoSizeText(
                'TUS EVENTOS',
                maxLines: 1,
                style: TextStyle(
                    color: ProjectColors.secondary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
              FutureBuilder<dynamic>(
                future: eventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    int eventCount = snapshot.data!.length;
                    if (eventCount == 0) {
                      return SizedBox(
                        height: size.height * 0.6,
                        width: size.width * 0.8,
                        child: const Center(
                            child: AutoSizeText(
                                'No estás en ningún evento, crea o únete a uno',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ProjectColors.tertiary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))),
                      );
                    } else {
                      return ConstrainedBox(
                        constraints:
                            BoxConstraints(maxHeight: size.height * 0.68),
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => EventContainer(
                            event: snapshot.data![index],
                          ),
                        ),
                      );
                    }
                  } else {
                    return Column(children: const [
                      SizedBox(height: 100),
                      Center(child: CircularProgressIndicator())
                    ]);
                  }
                },
              ),
            ],
          ),
        ));
  }
}
