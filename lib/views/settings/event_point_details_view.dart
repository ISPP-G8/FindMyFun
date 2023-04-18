import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/helpers/helpers.dart';
import 'package:findmyfun/models/event_point.dart';
import 'package:findmyfun/themes/colors.dart';
import 'package:findmyfun/ui/show_circular_progress_dialog.dart';
import 'package:findmyfun/widgets/custom_text_form.dart';
import 'package:findmyfun/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';

class EventPointDetailsView extends StatefulWidget {
  @override
  State<EventPointDetailsView> createState() => _EventPointDetailsViewState();
}

class _EventPointDetailsViewState extends State<EventPointDetailsView> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _imageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final eventPoint = ModalRoute.of(context)!.settings.arguments as EventPoint;
    final eventPointsService = Provider.of<EventPointsService>(context);
    final usersService = Provider.of<UsersService>(context);

    _nameController.text = eventPoint.name;
    _descriptionController.text = eventPoint.description;
    _addressController.text = eventPoint.address;
    _cityController.text = eventPoint.city;
    _countryController.text = eventPoint.country;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Detalles de punto de evento',
            style: TextStyle(color: ProjectColors.secondary),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
              size: 44,
              color: ProjectColors.secondary,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  showCircularProgressDialog(context);
                  await eventPointsService.deleteEventPoint(eventPoint.id);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: CachedNetworkImage(imageUrl: eventPoint.image)),
                CustomTextForm(
                  hintText: 'Nombre',
                  controller: _nameController,
                  validator: (p0) => Validators.validateNotEmpty(p0),
                ),
                CustomTextForm(
                  hintText: 'Descripción',
                  controller: _descriptionController,
                  validator: (p0) => Validators.validateNotEmpty(p0),
                ),
                CustomTextForm(
                  hintText: 'Dirección',
                  controller: _addressController,
                  validator: (p0) => Validators.validateNotEmpty(p0),
                ),
                CustomTextForm(
                  hintText: 'Ciudad',
                  controller: _cityController,
                  validator: (p0) => Validators.validateNotEmpty(p0),
                ),
                CustomTextForm(
                  hintText: 'Pais',
                  controller: _countryController,
                  validator: (p0) => Validators.validateNotEmpty(p0),
                ),
                GestureDetector(
                  onTap: () async {
                    showCircularProgressDialog(context);
                    eventPoint.image = await uploadImage(context,
                        imageId: eventPoint.id, route: 'EventPoints');
                    Navigator.pop(context);
                  },
                  child: const CustomTextForm(
                    hintText: 'Pulsa aquí para seleccionar una imagen',
                    maxLines: 2,
                    enabled: false,
                  ),
                ),
                SubmitButton(
                  text: 'Actualizar',
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      eventPoint.address = _addressController.text;
                      eventPoint.name = _nameController.text;
                      eventPoint.city = _cityController.text;
                      eventPoint.country = _countryController.text;
                      eventPoint.description = _descriptionController.text;

                      showCircularProgressDialog(context);
                      await eventPointsService.saveEventPoint(
                          eventPoint, usersService.currentUser!);

                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
