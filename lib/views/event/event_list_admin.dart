import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:findmyfun/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventListViewAdmin extends StatefulWidget {
  const EventListViewAdmin({super.key});

  @override
  State<EventListViewAdmin> createState() => _EventListViewAdmin();
}

class _EventListViewAdmin extends State<EventListViewAdmin> {
  @override
  void initState() {
    final eventsService = Provider.of<EventsService>(context, listen: false);
    Future.delayed(Duration.zero, () async => await eventsService.getEvents());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final eventsService = Provider.of<EventsService>(context);
    // final users = usersService.users;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.chevron_left,
                  size: 45,
                  color: ProjectColors.secondary,
                )),
            backgroundColor: ProjectColors.primary,
            elevation: 0,
            centerTitle: true,
            title: Text('EVENTOS',
                textAlign: TextAlign.center, style: Styles.appBar),
          ),
          backgroundColor: ProjectColors.primary,
          body: Column(children: [
            const SizedBox(
              height: 20,
            ),
            UsersContainer(
              child: _EventsColumn(
                events: eventsService.events,
              ),
            )
          ])),
    );
  }
}

class _EventsColumn extends StatelessWidget {
  final List<Event> events;
  const _EventsColumn({required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
            height: 500,
            width: 325,
            child: ListView.separated(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                    title: Text(event.name),
                    subtitle: Text('${event.address} \n${event.city}'),
                    onTap: () => Navigator.pushNamed(
                        context, 'eventDetailsAdmin',
                        arguments: event));
              },
              separatorBuilder: (context, index) => const Divider(),
            )),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
