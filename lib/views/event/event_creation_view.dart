import 'package:findmyfun/models/event.dart';
import 'package:findmyfun/services/auth_service.dart';
import 'package:findmyfun/services/events_service.dart';
import 'package:findmyfun/services/preferences_service.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/validators.dart';
import '../../ui/custom_snackbars.dart';

class EventCreationView extends StatelessWidget {
  const EventCreationView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: ProjectColors.primary,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Center(
                  child: Text(
                'CREAR EVENTO',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                )),
                const SizedBox(
                  height: 20,
                ),
                LoginContainer(
                  child: _FormsColumn(),
                ),
              ]
            )
          )),
    );
  }
}

class _FormsColumn extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();
  final _description = TextEditingController();
  final _image = TextEditingController();
  final _startDateTime = TextEditingController();
  List<Object> _selectedValues = [];
  // final _tags = const CategoryDropdown(onSelectionChanged: ,);

  _FormsColumn();

  @override
  Widget build(BuildContext context) {
    String? id = AuthService().currentUser?.uid ?? "";
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CustomTextForm(
            hintText: 'Nombre del evento',
            controller: _name,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Lugar',
            controller: _address,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Ciudad',
            controller: _city,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'País',
            controller: _country,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Descripción',
            maxLines: 5,
            type: TextInputType.multiline,
            controller: _description,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Link de la imagen',
            controller: _image,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Fecha y hora: aaaa-MM-dd hh:mm',
            controller: _startDateTime,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CategoryDropdown(
            selectedValues: _selectedValues,
            onSelectionChanged: (selected) {
              _selectedValues = selected;
            },
          ),
          SubmitButton(
            text: 'CONTINUAR',
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                showDialog(
                  context: context,
                  builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()),
                      ]),
                );
                await EventsService().saveEvent(Event(
                    address: _address.text,
                    city: _city.text,
                    country: _country.text,
                    description: _description.text,
                    finished: false,
                    image: _image.text,
                    name: _name.text,
                    startDate: DateTime.parse(_startDateTime.text),
                    tags: await Future.wait(_selectedValues
                        .map((e) => PreferencesService()
                            .getPreferenceByName(e.toString()))
                        .toList()),
                    users: [id],
                    id: Uuid().v1()));

                await Future.delayed(const Duration(seconds: 1));
                Navigator.pushReplacementNamed(context, 'main');
              } else {
                CustomSnackbars.showCustomSnackbar(
                  context,
                  const Text('Rellene los campos'),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
