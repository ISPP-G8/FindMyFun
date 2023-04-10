import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/helpers/helpers.dart';
import 'package:findmyfun/models/event_point.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/ui/ui.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/services.dart';

List<Marker> tappedMarkerEventPoint = [];

class EventPointCreationScreen extends StatefulWidget {
  const EventPointCreationScreen({Key? key}) : super(key: key);

  @override
  State<EventPointCreationScreen> createState() =>
      _EventPointCreationScreenState();
}

class _EventPointCreationScreenState extends State<EventPointCreationScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
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
                    GestureDetector(
                      onTap: () async {
                        // Muestra el circulo de progreso
                        showCircularProgressDialog(context);

                        // Coge la imagen de la galería, la sube a storage y devuelve el url.
                        imageUrl = await uploadImage(context,
                            imageId: eventPointId, route: 'EventPoints');

                        // ignore: use_build_context_synchronously
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
                    Divider(
                      thickness: 7,
                      color: ProjectColors.tertiary,
                      indent: size.height * 0.05,
                      endIndent: size.height * 0.05,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: size.height * 0.5,
                          maxWidth: size.width * 0.8),
                      child: const MapPlaceSelectorEventPointScreen(),
                    ),
                    Divider(
                      thickness: 7,
                      color: ProjectColors.tertiary,
                      indent: size.height * 0.05,
                      endIndent: size.height * 0.05,
                    ),
                    CustomTextForm(
                      hintText: 'Nombre',
                      controller: _nameController,
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
                                          child: const Text('Ok'),
                                        )
                                      ],
                                      content: const Text(
                                          'Por favor, seleccione una imagen'),
                                    ),
                                  );
                                  return;
                                }

                                Marker selectedMarker =
                                    tappedMarkerEventPoint[0];

                                List<Placemark> selectedPlaceMark =
                                    await placemarkFromCoordinates(
                                        selectedMarker.position.latitude,
                                        selectedMarker.position.longitude);

                                Placemark placeMark = selectedPlaceMark[0];

                                final eventPoint = EventPoint(
                                    name: _nameController.text,
                                    description: _descriptionController.text,
                                    longitude:
                                        selectedMarker.position.longitude,
                                    latitude: selectedMarker.position.latitude,
                                    address: placeMark.street!,
                                    city: placeMark.locality!,
                                    country: placeMark.country!,
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

class MapPlaceSelectorEventPointScreen extends StatefulWidget {
  const MapPlaceSelectorEventPointScreen({super.key});

  @override
  State<MapPlaceSelectorEventPointScreen> createState() =>
      _MapPlaceSelectorEventPointScreen();
}

class _MapPlaceSelectorEventPointScreen
    extends State<MapPlaceSelectorEventPointScreen> {
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
          markers: Set.from(tappedMarkerEventPoint),
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
      tappedMarkerEventPoint.clear();
      tappedMarkerEventPoint.add(Marker(
          markerId: MarkerId(tappedPoint.toString()), position: tappedPoint));
    });
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
