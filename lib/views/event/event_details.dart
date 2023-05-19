// ignore_for_file: depend_on_referenced_packages
import 'package:auto_size_text/auto_size_text.dart';
import 'package:findmyfun/helpers/helpers.dart';
import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../ui/ui.dart';

class EventDetailsView extends StatefulWidget {
  const EventDetailsView({super.key});

  @override
  State<EventDetailsView> createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
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
            actions: [
              Visibility(
                visible:
                    selectedEvent.creator == AuthService().currentUser!.uid,
                child: GestureDetector(
                  onTap: () => setState(() {
                    canEdit = !canEdit;
                  }),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.edit,
                      size: 25,
                      color: canEdit
                          ? ProjectColors.tertiary
                          : ProjectColors.secondary,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        // backgroundColor: ProjectColors.primary,
        body: SingleChildScrollView(
          child: LoginContainer(
            child: _FormsColumn(
              canEdit: canEdit,
            ),
          ),
        ),
      ),
    );
  }
}

class _FormsColumn extends StatefulWidget {
  final bool canEdit;
  const _FormsColumn({this.canEdit = false});

  @override
  State<_FormsColumn> createState() => _FormsColumnState();
}

class _FormsColumnState extends State<_FormsColumn> {
  final _formKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _startDateTime = TextEditingController();
  final _locationController = TextEditingController();
  final _cityController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final selectedEvent = ModalRoute.of(context)!.settings.arguments as Event;
    final eventService = Provider.of<EventsService>(context, listen: false);
    final userService = Provider.of<UsersService>(context, listen: false);
    final creator = userService.getUserWithUid(selectedEvent.creator);
    String activeUserId = AuthService().currentUser?.uid ?? "";
    final activeUserFuture = userService.getCurrentUserWithUid();

    _description.text = selectedEvent.description;
    _startDateTime.text = selectedEvent.startDate.toIso8601String();
    _locationController.text = selectedEvent.address;
    _cityController.text = selectedEvent.city;

    //List<String> asistentesList = [];
    Future<List<String>> asistentes = Future.delayed(Duration.zero, () async {
      List<String> users = await eventService.getUsersFromEvent(selectedEvent);
      List<String> names = await eventService.getNameFromId(users);
      return names;
      //asistentesList = names;
    });

    //print(asistentes);
    bool creatorSameAsCurrentUser = activeUserId == selectedEvent.creator;

    return FutureBuilder<User>(
      future: creator,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.005),
                const AdPlanLoader(),
                const SizedBox(
                  height: 10,
                ),
                Image.network(
                  selectedEvent.image,
                  fit: BoxFit.cover,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                const Text(
                  'Dirección:',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextDetail(
                  hintText: selectedEvent.address,
                  enabled: widget.canEdit,
                  controller: _locationController,
                  validator: (val) => Validators.validateNotEmpty(val),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                const Text(
                  'Ciudad:',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextDetail(
                  hintText: selectedEvent.city,
                  enabled: widget.canEdit,
                  controller: _cityController,
                  validator: (val) => Validators.validateNotEmpty(val),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                const Text(
                  'Fecha:',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextDetail(
                  hintText: DateFormat('yyyy-MM-dd HH:mm')
                      .format(selectedEvent.startDate),
                  enabled: widget.canEdit,
                  maxLines: 3,
                  controller: _startDateTime,
                  validator: (val) => Validators.validateNotEmpty(
                    val,
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                const Text(
                  'Descripción:',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextDetail(
                  hintText: selectedEvent.description,
                  enabled: widget.canEdit,
                  maxLines: 5,
                  type: TextInputType.multiline,
                  controller: _description,
                  validator: (val) => Validators.validateNotEmpty(val),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                if (!creatorSameAsCurrentUser)
                  EventCreator(
                    creatorUsername: snapshot.data?.username ?? 'username',
                    event: selectedEvent,
                  ),
                if (creatorSameAsCurrentUser && !widget.canEdit)
                  GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'profile'),
                      child: const CustomButton(text: 'Mi perfil')),
                const SizedBox(
                  height: 20,
                ),
                if (widget.canEdit)
                  SubmitButton(
                    text: 'Guardar cambios',
                    onTap: () async {
                      if (!_formKey.currentState!.validate()) return;
                      User user = await UsersService().getCurrentUserWithUid();
                      final event = Event(
                          address: _locationController.text,
                          city: _cityController.text,
                          country: _locationController.text,
                          description: _description.text,
                          visibleFrom:
                              user.subscription.maxVisiblityOfEventsInDays == -1
                                  ? DateTime.fromMillisecondsSinceEpoch(0)
                                  : DateTime.parse(_startDateTime.text)
                                      .subtract(Duration(
                                          days: user.subscription
                                              .maxVisiblityOfEventsInDays)),
                          id: selectedEvent.id,
                          image: selectedEvent.image,
                          name: selectedEvent.name,
                          latitude: selectedEvent.latitude,
                          longitude: selectedEvent.longitude,
                          startDate: DateTime.parse(_startDateTime.text),
                          tags: selectedEvent.tags,
                          users: selectedEvent.users,
                          maxUsers: selectedEvent.maxUsers,
                          messages: selectedEvent.messages);
                      // ignore: use_build_context_synchronously
                      showCircularProgressDialog(context);
                      final eventService =
                          // ignore: use_build_context_synchronously
                          Provider.of<EventsService>(context, listen: false);
                      // ignore: use_build_context_synchronously
                      await eventService.saveEvent(context, event);
                      // await eventService.getEventsOfLoggedUser();

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                  ),
                FutureBuilder<User>(
                  future: activeUserFuture,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        !selectedEvent.users.contains(activeUserId) &&
                        !selectedEvent.isFull &&
                        snapshot.data!.subscription.type !=
                            SubscriptionType.company) {
                      return SubmitButton(
                        text: 'Unirse',
                        onTap: () => {
                          eventService.addUserToEvent(context, selectedEvent),
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EventDetailsView(),
                                  settings:
                                      RouteSettings(arguments: selectedEvent)))
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                if (selectedEvent.users.contains(activeUserId) &&
                    !widget.canEdit)
                  ElevatedButton(
                    child: const AutoSizeText(
                      'Abrir chat',
                      maxLines: 1,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, 'chat',
                          arguments: selectedEvent);
                    },
                  ),
                if (!widget.canEdit)
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
            ),
          );
        } else {
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
              const SizedBox(
                height: 10,
              ),
              EventCreator(
                creatorUsername: snapshot.data?.username ?? 'username',
                event: selectedEvent,
              ),
              const SizedBox(
                height: 20,
              ),
              if (!selectedEvent.users.contains(activeUserId))
                SubmitButton(
                  text: 'Unirse',
                  onTap: () => {
                    eventService.addUserToEvent(context, selectedEvent),
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EventDetailsView(),
                            settings: RouteSettings(arguments: selectedEvent)))
                  },
                ),
              ElevatedButton(
                child: const AutoSizeText(
                  'Abrir chat',
                  maxLines: 1,
                ),
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
