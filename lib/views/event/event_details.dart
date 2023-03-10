import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:findmyfun/screens/access_screen.dart';

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
    // User eventCreator = UsersService().getUserWithUid(selectedEvent.users[0]);
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
        const EventCreator(
          creatorUsername:
              'eventCreator', //AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        ),
        const SubmitButton(
          text: 'Unirse',
          // onTap: () => Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) => const AccessScreen()),
          // ),
          // onTap: () => ,
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
