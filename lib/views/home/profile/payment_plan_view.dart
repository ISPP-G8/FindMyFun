// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/models/models.dart' as user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/validators.dart';
import '../../../services/services.dart';
import '../../../themes/colors.dart';
import '../../../themes/styles.dart';
import '../../../ui/custom_snackbars.dart';
import '../../../widgets/widgets.dart';

class PaymentPlanView extends StatelessWidget {
  const PaymentPlanView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          // backgroundColor: ProjectColors.primary,
          body: SingleChildScrollView(
              child: Column(children: [
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
          ]))),
    );
  }
}

// ignore: must_be_immutable
class _FormsColumn extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();
  final _description = TextEditingController();
  final _image = TextEditingController();
  final _startDateTime = TextEditingController();
  final _startTime = TextEditingController();
  List<Object> _selectedValues = [];
  // final _tags = const CategoryDropdown(onSelectionChanged: ,);

  _FormsColumn();

  @override
  Widget build(BuildContext context) {
    String? id = AuthService().currentUser?.uid ?? "";
    return Form(
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            'DATOS DE PAGO',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ProjectColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 35),
          ),
          CustomTextForm(
            hintText: 'Nombre del titular',
            controller: _name,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Numero de tarjeta',
            controller: _address,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Caducidad',
            controller: _city,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'CVV',
            controller: _country,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          SubmitButton(
            text: 'CONTINUAR',
            onTap: () async {
              if (_formKey.currentState!.validate() &&
                  _selectedValues.isNotEmpty) {
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
                /* final eventsService =
                    Provider.of<EventsService>(context, listen: false);
                await eventsService.saveEvent(Event(
                    address: _address.text,
                    city: _city.text,
                    country: _country.text,
                    description: _description.text,
                    finished: false,
                    image: _image.text,
                    name: _name.text,
                    latitude: double.parse(_latitude.text),
                    longitude: double.parse(_longitude.text),
                    startDate: DateTime.parse(
                        '${_startDateTime.text} ${_startTime.text}'),
                    tags: await Future.wait(_selectedValues
                        .map((e) => PreferencesService()
                            .getPreferenceByName(e.toString()))
                        .toList()),
                    users: [id],
                    messages: [
                      Messages(
                          userId: "8AH3CM76DydLFLrAQANT2gTBYlk2",
                          date: DateTime.now(),
                          text: "Bienvenido")
                    ],
                    id: const Uuid().v1())); */
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                final pageController =
                    // ignore: use_build_context_synchronously
                    Provider.of<PageViewService>(context, listen: false);
                pageController.mainPageController.jumpToPage(0);
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
