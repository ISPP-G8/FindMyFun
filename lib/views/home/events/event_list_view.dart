import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return await eventsService.getEvents();
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
              const Center(
                  child: Text(
                'TODOS LOS EVENTOS',
                style: TextStyle(
                    color: ProjectColors.tertiary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              )),
              FutureBuilder<dynamic>(
                future: eventsFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: size.height),
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) => EventContainer(
                          event: snapshot.data![index],
                        ),
                      ),
                    );
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

// class _EventContainer extends StatelessWidget {
//   final Event event;
//   const _EventContainer({super.key, required this.event});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       decoration: const BoxDecoration(
//           color: ProjectColors.secondary,
//           boxShadow: [
//             BoxShadow(color: Colors.black54, spreadRadius: 1, blurRadius: 7)
//           ]),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     event.name,
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(event.startDate.toString()),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(event.address),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text('${event.users.length} asistente/s'),
//                 ],
//               ),
//               Spacer(),
//               Container(
//                   width: 150, height: 150, child: Image.network(event.image))
//             ],
//           ),
//           CustomButton(
//             text: 'Detalles',
//             onTap: () =>
//                 Navigator.pushNamed(context, 'eventDetails', arguments: event),
//           ),
//         ],
//       ),
//     );
//   }
// }
