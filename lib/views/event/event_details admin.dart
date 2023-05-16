// ignore_for_file: depend_on_referenced_packages
import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailsAdmin extends StatefulWidget {
  const EventDetailsAdmin({super.key});

  @override
  State<EventDetailsAdmin> createState() => _EventDetailsAdminState();
}

class _EventDetailsAdminState extends State<EventDetailsAdmin> {
  bool canEdit = false;
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
            actions: [
              GestureDetector(
                onTap: () => setState(() {
                  canEdit = !canEdit;
                }),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.edit,
                    size: 30,
                    color: canEdit
                        ? ProjectColors.tertiary
                        : ProjectColors.secondary,
                  ),
                ),
              )
            ],
            // backgroundColor: ProjectColors.primary,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        // backgroundColor: ProjectColors.primary,
        body: SingleChildScrollView(
          child: LoginContainer(
            child: _FormsColumn(canEdit),
          ),
        ),
      ),
    );
  }
}

class _FormsColumn extends StatefulWidget {
  final bool canEdit;
  const _FormsColumn(this.canEdit);

  @override
  State<_FormsColumn> createState() => _FormsColumnState();
}

class _FormsColumnState extends State<_FormsColumn> {
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _startDateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final selectedEvent = ModalRoute.of(context)!.settings.arguments as Event;
    final eventService = Provider.of<EventsService>(context, listen: false);
    final userService = Provider.of<UsersService>(context, listen: false);
    final creator = userService.getUserWithUid(selectedEvent.creator);

    _addressController.text = selectedEvent.address;
    _cityController.text = selectedEvent.city;
    _startDateController.text = selectedEvent.startDate.toIso8601String();
    _descriptionController.text = selectedEvent.description;

    return FutureBuilder<User>(
        future: creator,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          return Form(
            key: _formKey,
            child: Column(
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
                  controller: _addressController,
                  hintText: selectedEvent.address,
                  enabled: widget.canEdit,
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
                  controller: _cityController,
                  hintText: selectedEvent.city,
                  enabled: widget.canEdit,
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
                  controller: _startDateController,
                  hintText: selectedEvent.startDate.toString(),
                  enabled: widget.canEdit,
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
                  controller: _descriptionController,
                  hintText: selectedEvent.description,
                  enabled: widget.canEdit,
                  maxLines: 4,
                  type: TextInputType.multiline,
                ),
                // GestureDetector(
                //     onTap: () => Navigator.pushNamed(context, 'editEventAdmin',
                //         arguments: selectedEvent),
                //     child: const CustomButton(text: 'Editar evento')),
                GestureDetector(
                    onTap: () async {
                      final eventToSave = Event(
                          address: _addressController.text,
                          city: _cityController.text,
                          country: selectedEvent.country,
                          description: _descriptionController.text,
                          id: selectedEvent.id,
                          image: selectedEvent.image,
                          name: selectedEvent.name,
                          latitude: selectedEvent.latitude,
                          longitude: selectedEvent.longitude,
                          startDate: DateTime.parse(_startDateController.text),
                          visibleFrom: selectedEvent.visibleFrom,
                          tags: selectedEvent.tags,
                          users: selectedEvent.users,
                          maxUsers: selectedEvent.maxUsers,
                          messages: selectedEvent.messages);
                      // selectedEvent = eventToSave;c
                      await eventService.saveEvent(context, eventToSave);
                      print('Evento editado con id: ${selectedEvent.id}');
                      await eventService.getEvents();
                      Navigator.pop(context);
                    },
                    child: const CustomButton(text: 'Guardar evento')),

                GestureDetector(
                    onTap: () {
                      eventService.deleteEventAdmin(selectedEvent.id, context);
                      Navigator.pop(context);
                    },
                    child: const CustomButton(text: 'Borrar evento')),
              ],
            ),
          );
        });
  }
}
