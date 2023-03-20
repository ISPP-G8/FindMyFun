import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../services/events_service.dart';
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
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.392529, -5.994072),
    zoom: 13,
  );

  late GoogleMapController _googleMapController;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Marker markerDePrueba1 = const Marker(markerId: MarkerId("Evento 1"), position: LatLng(37.391123, -6.001676), 
      infoWindow: InfoWindow(
          title: 'Partido de tenis', 
      ),
    );
    Marker markerDePrueba2 = const Marker(markerId: MarkerId("Evento 2"), position: LatLng(37.391226, -5.997486),
      infoWindow: InfoWindow(
          title: 'Quedada en el centro', 
      ),
    );    
    Marker markerDePrueba3 = Marker(markerId: const MarkerId("Punto de Promoción"), position: const LatLng(37.389335, -5.988552),
      infoWindow: const InfoWindow(
          title: 'Oferta en los 100 Montaditos', 
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
    );

    List<Marker> markers = [markerDePrueba1, markerDePrueba2, markerDePrueba3];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            markers: Set<Marker>.from(markers),
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            mapType: MapType.normal,
          ),
        ],
      ),
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
