import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/helpers/helpers.dart';
import 'package:findmyfun/models/event_point.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/ui/ui.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Widget image = Image.asset('assets/placeholder.png');
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final eventPointsService = Provider.of<EventPointsService>(context);
    final usersService = Provider.of<UsersService>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const FittedBox(
            child: Text(
              'ESTABLECER PUNTO DE INTERÉS',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
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
                    GestureDetector(
                      onTap: () async {
                        final imagePicker = ImagePicker();

                        final XFile? pickedImage = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (pickedImage == null) return;
                        image = SizedBox(
                          width: 500,
                          height: 500,
                          child: Image.file(
                            File(pickedImage.path),
                            fit: BoxFit.cover,
                          ),
                        );
                        // TODO: Tenemos la imagen como un archivo, esto hay que subirlo a firebase storage y obtener el link.
                        setState(() {});
                      },
                      child: Container(
                        height: 200,
                        width: 200,
                        child: image,
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
                                final eventPoint = EventPoint(
                                    name: _nameController.text,
                                    description: _descriptionController.text,
                                    longitude: 0.0,
                                    latitude: 0.0,
                                    address: _addressController.text,
                                    city: _cityController.text,
                                    country: _countryController.text,
                                    image: '',
                                    id: const Uuid().v1());
                                showCircularProgressDialog(context);

                                await eventPointsService.saveEvent(
                                    eventPoint, usersService.currentUser!);

                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            },
                          ),
                          _Button(
                            title: 'CONTINUAR',
                            onTap: () => Navigator.pop(context),
                          ),
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

  const _Button({super.key, required this.title, this.onTap});

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
                color: Color(0xffffde59),
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
    );
  }
}
