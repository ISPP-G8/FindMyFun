import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EventListView extends StatelessWidget {
  const EventListView({super.key});


  @override
  Widget build(BuildContext context) {
    // final eventsService = Provider.of<EventsService>(context);
    // eventsService.getEvents();
    return Scaffold(
      backgroundColor: ProjectColors.primary,

      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(child: Text('Tus eventos', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),)),
      _EventContainer(title: 'Concierto The Who', date: 'JUE 15 ABR - 15:00 CET', location: 'Estadio Benito Villamarín', maxAssistants: 8,),
      _EventContainer(title: 'Concierto The Who', date: 'JUE 15 ABR - 15:00 CET', location: 'Estadio Benito Villamarín', maxAssistants: 8,),
      _EventContainer(title: 'Concierto The Who', date: 'JUE 15 ABR - 15:00 CET', location: 'Estadio Benito Villamarín', maxAssistants: 8,),
      _EventContainer(title: 'Concierto The Who', date: 'JUE 15 ABR - 15:00 CET', location: 'Estadio Benito Villamarín', maxAssistants: 8,),
      _EventContainer(title: 'Concierto The Who', date: 'JUE 15 ABR - 15:00 CET', location: 'Estadio Benito Villamarín', maxAssistants: 8,),
      _EventContainer(title: 'Concierto The Who', date: 'JUE 15 ABR - 15:00 CET', location: 'Estadio Benito Villamarín', maxAssistants: 8,),
          ],
      
        ),
      )
   );
  }
}

class _EventContainer extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final int maxAssistants;
  const _EventContainer({super.key, required this.title, required this.date, required this.location, required this.maxAssistants});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25)
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(date),
                  SizedBox(height: 10,),
                  Text(location),
                  SizedBox(height: 10,),
                  Text('5/$maxAssistants asistentes'),
    
    
                ],
              ),
              Spacer(),
              Container(
                width: 150,
                height: 150,
                child: Image.network('https://weezevent.com/wp-content/uploads/2018/08/27184514/organiser-un-concert-en-7-etapes.jpg'))
            ],
          )
        ],
      ),
    );
  }
}