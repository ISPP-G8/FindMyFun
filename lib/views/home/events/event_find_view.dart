import 'package:auto_size_text/auto_size_text.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventFindView extends StatefulWidget {
  const EventFindView({super.key});

  @override
  State<StatefulWidget> createState() => _EventFindView();
}

class _EventFindView extends State<EventFindView> {
  late Future eventsFuture;

  @override
  void initState() {
    super.initState();

    eventsFuture = _findEvents();
  }

  _findEvents() async {
    EventsService eventsService = EventsService();
    return await eventsService.findEvents();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            SizedBox(height: size.height * 0.005),
            const AdPlanLoader(),
            SizedBox(
              height: size.height * 0.02,
              width: size.width,
            ),
            const Center(
              child: AutoSizeText(
                'MAPA DE EVENTOS',
                maxLines: 1,
                style: TextStyle(
                    color: ProjectColors.tertiary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: size.height * 0.2),
              child: const MapScreen(),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
              height: 20,
              indent: 20,
              endIndent: 20,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const Center(
                    child: AutoSizeText(
                      'EVENTOS RECOMENDADOS',
                      maxLines: 1,
                      style: TextStyle(
                          color: ProjectColors.tertiary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder<dynamic>(
                    future: eventsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        int eventCount = snapshot.data!.length;
                        if (eventCount == 0) {
                          return SizedBox(
                            height: size.height * 0.29,
                            width: size.width * 0.8,
                            child: const Center(
                                child: AutoSizeText(
                                    'Ajusta tus preferencias para mostrar eventos recomendados',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: ProjectColors.tertiary,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))),
                          );
                        } else {
                          return ConstrainedBox(
                            constraints:
                                BoxConstraints(maxHeight: size.height * 0.30),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (_, index) => EventContainer(
                                event: snapshot.data![index],
                              ),
                            ),
                          );
                        }
                      } else {
                        return Column(children: const [
                          SizedBox(height: 100),
                          Center(child: CircularProgressIndicator())
                        ]);
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController _googleMapController;
  late Future markersFuture;
  // ignore: prefer_const_constructors
  LatLng currentPosition = LatLng(37.356342, -5.984759);
  bool hasCurrentPositionBeenUpdated = false;

  @override
  void initState() {
    super.initState();

    markersFuture = _getMarkers();

    _getUserCurrentLocation();
  }

  _getMarkers() async {
    MapService mapService = MapService();
    bool isEventCreation = false;
    return await mapService.getMarkers(isEventCreation);
  }

  _getUserCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    LatLng defaultPosition = const LatLng(37.356342, -5.984759);

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Servicios de localización desactivados");
      currentPosition = defaultPosition;
      hasCurrentPositionBeenUpdated = true;
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Permisos de localización rechazados");
        currentPosition = defaultPosition;
        hasCurrentPositionBeenUpdated = true;
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: "Permisos de localización rechazados de forma permanente");
      currentPosition = defaultPosition;
      hasCurrentPositionBeenUpdated = true;
      return null;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = LatLng(position.latitude, position.longitude);
    hasCurrentPositionBeenUpdated = true;
    setState(() {});
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: markersFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  markers: Set<Marker>.from(
                      snapshot.data!.map((m) => m.marker).toSet()),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        currentPosition.latitude, currentPosition.longitude),
                    zoom: 15,
                  ),
                  onMapCreated: (controller) =>
                      _googleMapController = controller,
                  mapType: MapType.normal,
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'map'),
                  child: Container(
                      decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0),
                  )),
                ),
              ],
            ),
          );
        } else {
          return Column(children: const [
            SizedBox(height: 100),
            Center(child: CircularProgressIndicator())
          ]);
        }
      },
    );
  }
}
