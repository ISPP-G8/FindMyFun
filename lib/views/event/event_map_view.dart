import 'package:cached_network_image/cached_network_image.dart';
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
    target: LatLng(37.392529, -5.994072),
    zoom: 13,
  );

  late GoogleMapController _googleMapController;
  late Future markersFuture;
  bool isEventDetailsVisible = false;

  @override
  void initState() {
    super.initState();

    markersFuture = _getMarkers();
  }

  _getMarkers() async {
    MapService mapService = MapService();
    return await mapService.getMarkers(isEventDetailsVisible);
  }


  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    Marker markerDePrueba3 = Marker(
      markerId: const MarkerId("Punto de Promoción"),
      position: const LatLng(37.389335, -5.988552),
      onTap: () => {
        setState(() {
          isEventDetailsVisible = !isEventDetailsVisible;
        }),
      },
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );
    
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
                  markers: Set<Marker>.from(snapshot.data!),
                  initialCameraPosition: _initialCameraPosition,
                  onMapCreated: (controller) => _googleMapController = controller,
                  mapType: MapType.normal,
                ),
                Visibility(
                  visible: isEventDetailsVisible,
                  child: GestureDetector(
                    // este onTap es para llevar a los detalles del evento, todavia sin implementar
                    // onTap: () => Navigator.pushNamed(context, 'eventDetails', arguments: event),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: ProjectColors.secondary,
                              boxShadow: [
                                BoxShadow(
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
                                    children: const [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Oferta en los 100 montaditos",
                                        style: TextStyle(
                                            decoration: TextDecoration.none,
                                            color: Colors.black,
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('19/08/2023 18:30',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            decoration: TextDecoration.none,
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Av. de la Constitución",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            decoration: TextDecoration.none,
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('3 asistente/s',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9,
                                            decoration: TextDecoration.none,
                                          )),
                                    ],
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                      width: 150,
                                      height: size.height * 0.12,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "https://media-cdn.tripadvisor.com/media/photo-s/02/e1/2e/ce/cerveceria-100-montaditos.jpg",
                                        errorWidget: (context, url, error) {
                                          print('Error al cargar la imagen $error');
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
                        )),
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
