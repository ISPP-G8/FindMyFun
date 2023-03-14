import 'dart:math';

import 'package:findmyfun/models/preferences.dart';
import 'package:findmyfun/services/events_service.dart';
import 'package:findmyfun/views/event/event_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:findmyfun/services/page_view_service.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/validators.dart';
import '../../models/event.dart';
import '../../services/preferences_service.dart';
import '../../themes/colors.dart';
import '../../themes/styles.dart';

class UpdateEventView extends StatelessWidget {
  const UpdateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageViewController =
        Provider.of<PageViewService>(context).pageController;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: ProjectColors.primary,
          body: SingleChildScrollView(
              child: Column(children: [
            Center(
                child: Text(
              'MODIFICAR EVENTO',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: 20,
            ),
            LoginContainer(
              child: _FormsColumn(),
            )
          ]))),
    );
  }
}

class _FormsColumn extends StatelessWidget {
  _FormsColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Event event = ModalRoute.of(context)!.settings.arguments as Event;

    final formKey = GlobalKey<FormState>();
    final name = TextEditingController(text: event.name);
    final address = TextEditingController(text: event.address);
    final city = TextEditingController(text: event.city);
    final country = TextEditingController(text: event.country);
    final description = TextEditingController(text: event.description);
    final image = TextEditingController(text: event.image);
    final startDateTime =
        TextEditingController(text: event.startDate.toIso8601String());
    List<Object> selectedValues = event.tags.map((e) => e.name).toList();

    return Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CustomTextForm(
              hintText: 'Nombre del evento',
              controller: name,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            CustomTextForm(
              hintText: 'Lugar',
              controller: address,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            CustomTextForm(
              hintText: 'Ciudad',
              controller: city,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            CustomTextForm(
              hintText: 'País',
              controller: country,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            CustomTextForm(
              hintText: 'Descripción',
              maxLines: 5,
              type: TextInputType.multiline,
              controller: description,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            CustomTextForm(
              hintText: 'Link de la imagen',
              controller: image,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            CustomTextForm(
              hintText: 'Fecha y hora: aaaa-MM-dd hh:mm',
              controller: startDateTime,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            CategoryDropdown(
              selectedValues: selectedValues,
              onSelectionChanged: (selected) {
                selectedValues = selected;
              },
            ),
            SubmitButton(
                text: 'CONTINUAR',
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator()),
                          ]),
                    );
                    try {
                      event.address = address.text;
                      event.city = city.text;
                      event.country = country.text;
                      event.description = description.text;
                      event.finished = false;
                      event.image = image.text;
                      event.name = name.text;
                      event.startDate = DateTime.parse(startDateTime.text);
                      event.tags = await Future.wait(selectedValues
                          .map((e) => PreferencesService()
                              .getPreferenceByName(e.toString()))
                          .toList());

                      await EventsService().updateEvent(event);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventDetailsView(),
                              settings: RouteSettings(arguments: event)));
                    } on FirebaseException catch (e) {
                      print('Hay un error al actualizar el evento $e');
                      Navigator.pop(context);
                    }
                  }
                })
          ],
        ));
  }
}
