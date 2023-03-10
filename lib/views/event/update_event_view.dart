import 'package:findmyfun/services/events_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:findmyfun/services/page_view_service.dart';
import 'package:findmyfun/widgets/widgets.dart';

import '../../helpers/validators.dart';
import '../../models/event.dart';
import '../../themes/colors.dart';
import '../../themes/styles.dart';

class UpdateEventView extends StatelessWidget {
  const UpdateEventView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageViewController =
        Provider.of<PageViewService>(context).pageController;

    return Scaffold(
        backgroundColor: ProjectColors.primary,
        body: Container(
          alignment: Alignment.center,
          // padding: const EdgeInsetsDirectional.only(top: 25.0),
          child: PageView(
            children: [
              SafeArea(
                child: Scaffold(
                    resizeToAvoidBottomInset: true,
                    appBar: AppBar(
                      leading: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.chevron_left,
                            size: 45,
                          )),
                      backgroundColor: ProjectColors.primary,
                      elevation: 0,
                      centerTitle: true,
                      title: Text('MODIFICAR EVENTO',
                          textAlign: TextAlign.center, style: Styles.appBar),
                    ),
                    backgroundColor: ProjectColors.primary,
                    body: const SingleChildScrollView(
                      child: LoginContainer(
                        child: _FormsColumn(),
                      ),
                    )),
              )
            ],
          ),
        ));
  }
}

class _FormsColumn extends StatefulWidget {
  const _FormsColumn({
    super.key,
  });

  @override
  State<_FormsColumn> createState() => _FormsColumnState();
}

class _FormsColumnState extends State<_FormsColumn> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Event event = ModalRoute.of(context)!.settings.arguments as Event;

    final eventNameController = TextEditingController(text: event.name);
    final placeController = TextEditingController(text: event.address);
    final descriptionController =
        TextEditingController(text: event.description);
    final imageController = TextEditingController(text: event.image);
    final datetimeController =
        TextEditingController(text: event.startDate.toIso8601String());

    return Form(
        key: GlobalKey<FormState>(),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CustomTextForm(
              hintText: 'Nombre del evento',
              controller: eventNameController,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            CustomTextForm(
              hintText: 'Lugar',
              controller: placeController,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            CustomTextForm(
              hintText: 'Descripción',
              maxLines: 5,
              type: TextInputType.multiline,
              controller: descriptionController,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            CustomTextForm(
              hintText: 'Link de la imagen',
              controller: imageController,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            CustomTextForm(
              hintText: 'Fecha y hora',
              type: TextInputType.datetime,
              controller: datetimeController,
              validator: (value) => Validators.validateNotEmpty(value),
            ),
            const CategoryDropdown(),
            SubmitButton(
                text: 'CONTINUAR',
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
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
                      event.name = eventNameController.text;
                      event.address = placeController.text;
                      event.description = descriptionController.text;
                      // event.image = DateTime.parse(datetimeController.text);
                      event.startDate = DateTime.parse(datetimeController.text);

                      await EventsService().updateEvent(event);
                    } on FirebaseException catch (e) {
                      print('Hay un error al actualizar el evento $e');
                      Navigator.pop(context);
                      return;
                    }
                  }
                })
          ],
        ));
  }
}
