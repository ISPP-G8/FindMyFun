import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:findmyfun/screens/access_screen.dart';
import 'package:provider/provider.dart';

import '../../models/event.dart';
import '../../models/user.dart';

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
              ),
            ),
            backgroundColor: ProjectColors.primary,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        backgroundColor: ProjectColors.primary,
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

    User eventCreator = User(
        id: "1",
        name: "a",
        surname: "a",
        username: "a",
        city: "a",
        email: "a",
        preferences: [], image: '');
    userService.getUserWithUid(selectedEvent.users.first).then((value) {
      eventCreator = value;
    });
    String activeUserId = AuthService().currentUser?.uid ?? "";

    //User eventCreator = UsersService().getUserWithUid(selectedEvent.users[0]);
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
          creatorUsername: eventCreator.username,
        ),
        if(!selectedEvent.users.contains(activeUserId))
          SubmitButton(
          text: 'Unirse',
          onTap: () => eventService.addUserToEvent(selectedEvent),
          ),
        const SubmitButton(
          text: 'Chat',
          // onTap: () => Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) => const AccessScreen()),
          // ),
          // onTap: => (),
        ),
      ],
    );
  }
}
