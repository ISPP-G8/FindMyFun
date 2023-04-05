import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

import '../../helpers/validators.dart';
import '../../services/services.dart';
import '../../ui/custom_snackbars.dart';

List<Marker> tappedMarkerEvent = [];

class EventCreationView extends StatelessWidget {
  const EventCreationView({super.key});

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
    final size = MediaQuery.of(context).size;
    String? id = AuthService().currentUser?.uid ?? "";
    return Form(
      // autovalidateMode: AutovalidateMode.onUserInteraction,
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
            hintText: 'Descripción',
            maxLines: 5,
            type: TextInputType.multiline,
            controller: _description,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          Divider(
            thickness: 7,
            color: ProjectColors.tertiary,
            indent: size.height * 0.05,
            endIndent: size.height * 0.05,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: size.height * 0.5, maxWidth: size.width * 0.8),
            child: const MapPlaceSelectorEventScreen(),
          ),
          Divider(
            thickness: 7,
            color: ProjectColors.tertiary,
            indent: size.height * 0.05,
            endIndent: size.height * 0.05,
          ),
          CustomTextForm(
            hintText: 'Link de la imagen',
            controller: _image,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Fecha: aaaa-MM-dd',
            controller: _startDateTime,
            validator: (value) => Validators.validateDate(value),
          ),
          CustomTextForm(
            hintText: 'Hora: HH:mm',
            controller: _startTime,
            validator: (value) => Validators.validateTime(value),
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
                final eventsService =
                    Provider.of<EventsService>(context, listen: false);

                Marker selectedMarker = tappedMarkerEvent[0];

                List<Placemark> selectedPlaceMark =
                    await placemarkFromCoordinates(
                        selectedMarker.position.latitude,
                        selectedMarker.position.longitude);

                Placemark placeMark = selectedPlaceMark[0];

                await eventsService.saveEvent(Event(
                    address: placeMark.street!,
                    city: placeMark.locality!,
                    country: placeMark.country!,
                    description: _description.text,
                    finished: false,
                    image: _image.text,
                    name: _name.text,
                    latitude: selectedMarker.position.latitude,
                    longitude: selectedMarker.position.longitude,
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
                    id: const Uuid().v1()));
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

class MapPlaceSelectorEventScreen extends StatefulWidget {
  const MapPlaceSelectorEventScreen({super.key});

  @override
  State<MapPlaceSelectorEventScreen> createState() =>
      _MapPlaceSelectorEventScreen();
}

class _MapPlaceSelectorEventScreen extends State<MapPlaceSelectorEventScreen> {
  late GoogleMapController _googleMapController;

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.356342, -5.984759),
    zoom: 13,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GoogleMap(
          initialCameraPosition: _initialCameraPosition,
          onMapCreated: (controller) => _googleMapController = controller,
          markers: Set.from(tappedMarkerEvent),
          onTap: _handleTapMarker,
          mapType: MapType.normal,
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
        ),
      ],
    );
  }

  _handleTapMarker(LatLng tappedPoint) {
    setState(() {
      tappedMarkerEvent.clear();
      tappedMarkerEvent.add(Marker(
          markerId: MarkerId(tappedPoint.toString()), position: tappedPoint));
    });
  }
}
