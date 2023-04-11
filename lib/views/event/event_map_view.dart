import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/models/models.dart';
import 'package:flutter/material.dart';
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
        title: Text('MAPA', textAlign: TextAlign.center, style: Styles.appBar),
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
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.356342, -5.984759),
    zoom: 13,
  );

  late GoogleMapController _googleMapController;
  late Future markersFuture;
  String? isEventDetailsVisible;

  @override
  void initState() {
    super.initState();

    markersFuture = _getMarkers();
  }

  _getMarkers() async {
    MapService mapService = MapService();
    return await mapService.getMarkers();
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
                  initialCameraPosition: _initialCameraPosition,
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
                              const Text(" Eventos a los que estás apuntado",
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
                              const Text(" Eventos disponibles",
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
                              const Text(" Puntos de evento disponibles",
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
                      onPressed: () => _googleMapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                              _initialCameraPosition)),
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
                                      Text(
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
                                      Text(
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
                                      Text(
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
                                      Text(
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

  // Usado para formularios para conseguir lat,long,city,address
  // _handleTap(LatLng tappedPos) {
  //   setState(() {
  //     markers = [];
  //     markers.add(Marker(
  //       markerId: MarkerId('${markers.length}'),
  //       position: tappedPos,
  //       // onTap: () => Navigator.pop(context, 'main'),
  //       infoWindow: const InfoWindow(
  //           title: 'Partido de fútbol', snippet: 'Partido de aficionados'),
  //       draggable: true,
  //     ));
  //   });
  // }
}
