import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/models/models.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:findmyfun/services/services.dart';
import '../../themes/colors.dart';
import '../../themes/styles.dart';

class EventMapView extends StatelessWidget {
  const EventMapView({super.key});

  @override
  Widget build(BuildContext context) {
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
        centerTitle: true,
        title: AutoSizeText('MAPA',
            maxLines: 1, textAlign: TextAlign.center, style: Styles.appBar),
      ),
      body: const MapScreen(),
    );
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
  String? isEventDetailsVisible;

  @override
  void initState() {
    super.initState();

    markersFuture = _getMarkers();

    _getUserCurrentLocation();
  }

  _getMarkers() async {
    MapService mapService = MapService();
    return await mapService.getMarkers();
  }

  _getUserCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = LatLng(position.latitude, position.longitude);
    setState(() {});
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FutureBuilder<dynamic>(
      future: markersFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Point> points = snapshot.data!;

          dynamic selectedEvent;

          if (isEventDetailsVisible != null) {
            dynamic event = points
                .where((p) => p.marker.markerId.value == isEventDetailsVisible)
                .map((p) => p.event)
                .toList()
                .first;

            if (event is Event) {
              selectedEvent = event;
            } else if (event is EventPoint) {
              selectedEvent = event;
            }
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  markers: Set<Marker>.from(points
                      .map((m) => m.marker)
                      .map((m) => m.copyWith(
                          onTapParam: () => setState(() {
                                isEventDetailsVisible =
                                    isEventDetailsVisible != m.markerId.value
                                        ? m.markerId.value
                                        : null;
                              })))
                      .toSet()),
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        currentPosition.latitude, currentPosition.longitude),
                    zoom: 15,
                  ),
                  myLocationEnabled: true,
                  compassEnabled: true,
                  onMapCreated: (controller) =>
                      _googleMapController = controller,
                  mapType: MapType.normal,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      color: ProjectColors.primary.withOpacity(0.7),
                      padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.025,
                          horizontal: size.width * 0.01),
                      height: size.height * 0.13,
                      width: size.width * 0.7,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                color: Colors.pink,
                                height: 10,
                                width: 10,
                              ),
                              const AutoSizeText(
                                  " Eventos a los que estás apuntado",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    decoration: TextDecoration.none,
                                  )),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            children: [
                              Container(
                                color: Colors.red,
                                height: 10,
                                width: 10,
                              ),
                              const AutoSizeText(" Eventos disponibles",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    decoration: TextDecoration.none,
                                  )),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            children: [
                              Container(
                                color: Colors.purple,
                                height: 10,
                                width: 10,
                              ),
                              const AutoSizeText(
                                  " Puntos de evento disponibles",
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    decoration: TextDecoration.none,
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: FloatingActionButton(
                      backgroundColor: ProjectColors.tertiary.withOpacity(0.7),
                      onPressed: () async {
                        LatLng tempPosition = currentPosition;
                        _getUserCurrentLocation.call();
                        while (tempPosition == currentPosition) {
                          await Future.delayed(
                              const Duration(milliseconds: 50));
                        }
                        _googleMapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(currentPosition.latitude,
                                    currentPosition.longitude),
                                zoom: 15)));
                      },
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                ),
                Visibility(
                  visible: isEventDetailsVisible != null,
                  child: GestureDetector(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () => selectedEvent is Event
                            ? Navigator.pushNamed(context, 'eventDetails',
                                arguments: selectedEvent)
                            : null,
                        child: Container(
                          decoration: BoxDecoration(
                              color: ProjectColors.secondary.withOpacity(0.7),
                              // ignore: prefer_const_literals_to_create_immutables
                              boxShadow: [
                                const BoxShadow(
                                    color: Colors.black54,
                                    spreadRadius: 1,
                                    blurRadius: 7)
                              ]),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: size.height * 0.15,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AutoSizeText(
                                        selectedEvent != null
                                            ? selectedEvent.name
                                            : '',
                                        style: const TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.black,
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AutoSizeText(
                                          selectedEvent is Event
                                              ? selectedEvent.startDate
                                                  .toString()
                                              : "",
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            decoration: TextDecoration.none,
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AutoSizeText(
                                          selectedEvent != null
                                              ? selectedEvent.address
                                              : '',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            decoration: TextDecoration.none,
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AutoSizeText(
                                          selectedEvent is Event
                                              ? '${selectedEvent.users.length.toString()} asistente/s'
                                              : '',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            decoration: TextDecoration.none,
                                          )),
                                    ],
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                      width: size.width * 0.3,
                                      height: size.height * 0.12,
                                      child: CachedNetworkImage(
                                        imageUrl: selectedEvent != null
                                            ? selectedEvent.image
                                            : 'assets/placeholder.png',
                                        errorWidget: (context, url, error) {
                                          // ignore: avoid_print
                                          print(
                                              'Error al cargar la imagen $error');
                                          return Image.asset(
                                              'assets/placeholder.png');
                                        },
                                        progressIndicatorBuilder:
                                            (context, url, progress) =>
                                                CircularProgressIndicator(
                                          value: progress.progress,
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
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
