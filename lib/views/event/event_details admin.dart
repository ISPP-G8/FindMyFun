// ignore_for_file: depend_on_referenced_packages
import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailsAdmin extends StatelessWidget {
  const EventDetailsAdmin({super.key});

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
                  selectionColor: Colors.black,
                  maxLines: 3,
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'events'),
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
    final size = MediaQuery.of(context).size;
    final selectedEvent = ModalRoute.of(context)!.settings.arguments as Event;
    final eventService = Provider.of<EventsService>(context, listen: false);
    final userService = Provider.of<UsersService>(context, listen: false);
    final creator = userService.getUserWithUid(selectedEvent.creator);

    return FutureBuilder<User>(
      future: creator,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Image.network(
                selectedEvent.image,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Dirección:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextDetail(
                hintText: selectedEvent.address,
                enabled: false,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Ciudad:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextDetail(
                hintText: selectedEvent.city,
                enabled: false,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Fecha:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextDetail(
                hintText: selectedEvent.startDate.toString(),
                enabled: false,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Descripción:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomTextDetail(
                hintText: selectedEvent.description,
                enabled: false,
                maxLines: 4,
                type: TextInputType.multiline,
              ),
              // GestureDetector(
              //     onTap: () => Navigator.pushNamed(context, 'editEventAdmin',
              //         arguments: selectedEvent),
              //     child: const CustomButton(text: 'Editar evento')),
              GestureDetector(
                  onTap: () => EventsService()
                      .deleteEventAdmin(selectedEvent.id, context),
                  child: const CustomButton(text: 'Borrar evento')),
            ],
          );
        }
    );
  }
}
