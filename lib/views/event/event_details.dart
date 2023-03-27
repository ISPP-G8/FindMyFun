import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/event.dart';
import '../../models/user.dart';
import 'event_chat_view.dart';

class EventDetailsView extends StatelessWidget {
  const EventDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedEvent = ModalRoute.of(context)!.settings.arguments as Event;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            flexibleSpace: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 50),
              child: FittedBox(
                child: Text(
                  selectedEvent.name,
                  textAlign: TextAlign.center,
                  style: Styles.appBar,
                  maxLines: 3,
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.chevron_left,
                size: 45,
                color: ProjectColors.secondary,
              ),
            ),
            // backgroundColor: ProjectColors.primary,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        // backgroundColor: ProjectColors.primary,
        body: const SingleChildScrollView(
          child: LoginContainer(
            child: _FormsColumn(),
          ),
        ),
      ),
    );
  }
}

class _FormsColumn extends StatelessWidget {
  const _FormsColumn();

  @override
  Widget build(BuildContext context) {
    final selectedEvent = ModalRoute.of(context)!.settings.arguments as Event;
    final eventService = Provider.of<EventsService>(context, listen: false);
    final userService = Provider.of<UsersService>(context, listen: false);
    final creator = userService.getUserWithUid(selectedEvent.creator);

    //List<String> asistentesList = [];
    Future<List<String>> asistentes = Future.delayed(Duration.zero, () async {
      List<String> users = await eventService.getUsersFromEvent(selectedEvent);
      List<String> names = await eventService.getNameFromId(users);
      return names;
      //asistentesList = names;
    });

    //print(asistentes);
    String activeUserId = AuthService().currentUser?.uid ?? "";

    return FutureBuilder<User>(
      future: creator,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(
                  selectedEvent.image,
                  fit: BoxFit.cover,
                ),
              ),
              CustomTextForm(
                hintText: selectedEvent.address,
                enabled: false,
              ),
              CustomTextForm(
                hintText: selectedEvent.city,
                enabled: false,
              ),
              CustomTextForm(
                hintText: selectedEvent.startDate.toString(),
                enabled: false,
              ),
              CustomTextForm(
                hintText: selectedEvent.description,
                enabled: false,
                maxLines: 5,
                type: TextInputType.multiline,
              ),
              EventCreator(
                creatorUsername: snapshot.data?.username ?? 'username',
              ),
              if (!selectedEvent.users.contains(activeUserId))
                SubmitButton(
                  text: 'Unirse',
                  onTap: () => {
                    eventService.addUserToEvent(selectedEvent),
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EventDetailsView(),
                            settings: RouteSettings(arguments: selectedEvent)))
                  },
                ),
              if (selectedEvent.users.contains(activeUserId))
                ElevatedButton(
                  child: const Text('Abrir chat'),
                  onPressed: () {
                    Navigator.pushNamed(context, 'chat',
                        arguments: selectedEvent);
                  },
                ),
              FutureBuilder<List<String>>(
                future: asistentes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final asistentesList = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: asistentesList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(asistentesList[index]),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          );
        } else {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Image.network(
                  selectedEvent.image,
                  fit: BoxFit.cover,
                ),
              ),
              CustomTextForm(
                hintText: selectedEvent.address,
                enabled: false,
              ),
              CustomTextForm(
                hintText: selectedEvent.city,
                enabled: false,
              ),
              CustomTextForm(
                hintText: selectedEvent.country,
                enabled: false,
              ),
              CustomTextForm(
                hintText: selectedEvent.latitude.toString(),
                enabled: false,
              ),
              CustomTextForm(
                hintText: selectedEvent.longitude.toString(),
                enabled: false,
              ),
              CustomTextForm(
                hintText: selectedEvent.startDate.toString(),
                enabled: false,
              ),
              CustomTextForm(
                hintText: selectedEvent.description,
                enabled: false,
                maxLines: 5,
                type: TextInputType.multiline,
              ),
              EventCreator(
                creatorUsername: snapshot.data?.username ?? '',
              ),
              if (!selectedEvent.users.contains(activeUserId))
                SubmitButton(
                  text: 'Unirse',
                  onTap: () => {
                    eventService.addUserToEvent(selectedEvent),
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EventDetailsView(),
                            settings: RouteSettings(arguments: selectedEvent)))
                  },
                ),
              ElevatedButton(
                child: const Text('Abrir chat'),
                onPressed: () {
                  Navigator.popAndPushNamed(context, 'chat',
                      arguments: selectedEvent, result: selectedEvent.messages);
                },
              ),
            ],
          );
        }
      },
    );
  }
}
