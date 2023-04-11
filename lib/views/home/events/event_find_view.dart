import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
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
            const CustomAd(),
            SizedBox(
              height: size.height * 0.02,
            ),
            const Center(
                child: Text(
              'MAPA DE EVENTOS',
              style: TextStyle(
                  color: ProjectColors.tertiary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
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
            Divider(
              thickness: 5,
              color: ProjectColors.secondary,
              indent: size.height * 0.05,
              endIndent: size.height * 0.05,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'EVENTOS RECOMENDADOS',
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
                        return ConstrainedBox(
                          constraints:
                              BoxConstraints(maxHeight: size.height * 0.3),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => EventContainer(
                              event: snapshot.data![index],
                            ),
                          ),
                        );
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
                                            target: LatLng(currentPosition.latitude, currentPosition.longitude),
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
// class _EventContainer extends StatelessWidget {
//   final Event event;
//   const _EventContainer({super.key, required this.event});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(25)),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Column(
//                 children: [
//                   Text(
//                     event.name,
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(event.startDate.toString()),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(event.address),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text('${event.users.length} asistente/s'),
//                 ],
//               ),
//               Spacer(),
//               Container(
//                   width: 150, height: 150, child: Image.network(event.image))
//             ],
//           ),
//           CustomButton(
//             text: 'Detalles',
//             onTap: () =>
//                 Navigator.pushNamed(context, 'eventDetails', arguments: event),
//           ),
//         ],
//       ),
//     );
//   }
// }
