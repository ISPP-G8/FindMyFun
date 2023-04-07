import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/helpers/helpers.dart';
import 'package:findmyfun/models/event_point.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/ui/ui.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../services/services.dart';

class EventPointCreationScreen extends StatefulWidget {
  const EventPointCreationScreen({Key? key}) : super(key: key);

  @override
  State<EventPointCreationScreen> createState() =>
      _EventPointCreationScreenState();
}

class _EventPointCreationScreenState extends State<EventPointCreationScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget placeholder = Container(
    alignment: Alignment.center,
    decoration: BoxDecoration(
        image: DecorationImage(
            image: Image.asset('assets/placeholder.png').image)),
    child: const Text(
      'Seleccione una imagen de su galería',
      textAlign: TextAlign.center,
    ),
  );
  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final eventPointsService = Provider.of<EventPointsService>(context);
    final usersService = Provider.of<UsersService>(context);
    final eventPointId = const Uuid().v1();
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.chevron_left,
                size: 45,
                color: ProjectColors.secondary,
              )),
          elevation: 0,
          title: const FittedBox(
            child: Text(
              'ESTABLECER PUNTO DE INTERÉS',
              style: TextStyle(
                  fontSize: 25,
                  color: ProjectColors.secondary,
                  fontWeight: FontWeight.bold),
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          color: ProjectColors.secondary,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: size.height),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const CustomAd(),
                    GestureDetector(
                      onTap: () async {
                        // Muestra el circulo de progreso
                        showCircularProgressDialog(context);

                        // Coge la imagen de la galería, la sube a storage y devuelve el url.
                        imageUrl = await uploadImage(context,
                            imageId: eventPointId, route: 'EventPoints');

                        Navigator.pop(
                            context); // Cierra el circulo de progreso.

                        setState(() {});
                      },
                      child: SizedBox(
                        height: 200,
                        width: 500,
                        child: imageUrl.isEmpty
                            ? placeholder
                            : CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.contain,
                                progressIndicatorBuilder:
                                    (context, url, progress) =>
                                        CircularProgressIndicator(
                                            value: progress.progress),
                              ),
                      ),
                    ),
                    CustomTextForm(
                      hintText: 'Nombre',
                      controller: _nameController,
                      validator: (value) => Validators.validateNotEmpty(value),
                    ),
                    CustomTextForm(
                      hintText: 'Pais',
                      controller: _countryController,
                      validator: (value) => Validators.validateNotEmpty(value),
                    ),
                    CustomTextForm(
                      hintText: 'Latitud',
                      controller: _latitudeController,
                      validator: (value) => Validators.validateNotEmpty(value),
                    ),
                    CustomTextForm(
                      hintText: 'Longitud',
                      controller: _longitudeController,
                      validator: (value) => Validators.validateNotEmpty(value),
                    ),
                    CustomTextForm(
                      hintText: 'Ciudad',
                      controller: _cityController,
                      validator: (value) => Validators.validateNotEmpty(value),
                    ),
                    CustomTextForm(
                      hintText: 'Dirección',
                      controller: _addressController,
                      validator: (value) => Validators.validateNotEmpty(value),
                    ),
                    CustomTextForm(
                      hintText: 'Descripción',
                      maxLines: 8,
                      controller: _descriptionController,
                      validator: (value) => Validators.validateNotEmpty(value),
                    ),
                    // Spacer(),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _Button(
                            title: 'CREAR EVENTO EN ESTE LUGAR',
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                if (imageUrl.isEmpty) {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      actions: [
                                        MaterialButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('Ok'),
                                        )
                                      ],
                                      content: Text(
                                          'Por favor, seleccione una imagen'),
                                    ),
                                  );
                                  return;
                                }
                                final eventPoint = EventPoint(
                                    name: _nameController.text,
                                    description: _descriptionController.text,
                                    longitude:
                                        double.parse(_longitudeController.text),
                                    latitude:
                                        double.parse(_latitudeController.text),
                                    address: _addressController.text,
                                    city: _cityController.text,
                                    country: _countryController.text,
                                    image: imageUrl,
                                    id: eventPointId);
                                showCircularProgressDialog(context);
                                await eventPointsService.saveEventPoint(
                                    eventPoint, usersService.currentUser!);

                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              }
                            },
                          ),
                          // _Button(
                          //   title: 'CONTINUAR',
                          //   onTap: () => Navigator.pop(context),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class _Button extends StatelessWidget {
  final String title;
  final void Function()? onTap;

  const _Button({required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      child: Container(
          alignment: Alignment.center,
          color: ProjectColors.buttonColor,
          width: size.width * 0.4,
          height: 80,
          padding: const EdgeInsets.all(10),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: ProjectColors.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}
