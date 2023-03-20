import 'package:findmyfun/services/events_service.dart';
import 'package:findmyfun/themes/styles.dart';
import 'package:findmyfun/views/event/event_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:findmyfun/services/page_view_service.dart';
import 'package:findmyfun/widgets/widgets.dart';

import '../../helpers/validators.dart';
import '../../models/event.dart';
import '../../services/preferences_service.dart';

class UpdateEventView extends StatelessWidget {
  const UpdateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageViewController =
        Provider.of<PageViewService>(context).pageController;

    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          //backgroundColor: ProjectColors.secondary,
          body: SingleChildScrollView(
              child: Column(children: [
            Center(
                child: Text(
              'MODIFICAR EVENTO',
              style: Styles.appBar,
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

    final List<String> splitsDateTime =
        DateFormat('yyyy-MM-dd HH:mm').format(event.startDate).split(" ");

    final startDate = TextEditingController(text: splitsDateTime[0]);

    final startTime = TextEditingController(text: splitsDateTime[1]);

    List<Object> selectedValues = event.tags.map((e) => e.name).toList();

    final eventsService = Provider.of<EventsService>(context, listen: false);


    return Form(
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
              hintText: 'Fecha: aaaa-MM-dd',
              controller: startDate,
              validator: (value) => Validators.validateDate(value),
            ),
            CustomTextForm(
              hintText: 'Hora: HH:mm',
              controller: startTime,
              validator: (value) => Validators.validateTime(value),
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
                  if (formKey.currentState!.validate() &&
                      selectedValues.isNotEmpty) {
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
                      event.startDate =
                          DateTime.parse('${startDate.text} ${startTime.text}');
                      event.tags = await Future.wait(selectedValues
                          .map((e) => PreferencesService()
                              .getPreferenceByName(e.toString()))
                          .toList());

                      await EventsService().updateEvent(event);
                      Navigator.popUntil(context, (route) => route.isFirst);
                      await eventsService.getEvents();
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
