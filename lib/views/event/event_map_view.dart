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
        title: Text('MAPA',
            textAlign: TextAlign.center, style: Styles.appBar),
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
    target: LatLng(37.392529,  -5.994072),
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
    
    final eventService = Provider.of<EventsService>(context, listen: false);
    List<Marker> markers = [];

    Marker marker = const Marker(
      markerId: MarkerId('Casa Juanma'), 
      position: LatLng(37.357937, -5.978426), 
      // onTap: () => Navigator.pop(context, 'main'),
      infoWindow: InfoWindow(
        title: 'Casa Juanma',
        snippet: 'Hola soy Juanma, esta es mi casa'
      ),
      draggable: true,
    );
    
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
            onTap: (position){
              setState(() {
                markers.add(
                  Marker(
                    markerId: MarkerId('${markers.length}'), 
                    position: LatLng(position.latitude,position.longitude), 
                    // onTap: () => Navigator.pop(context, 'main'),
                    infoWindow: const InfoWindow(
                      title: 'Casa Juanma',
                      snippet: 'Hola soy Juanma, esta es mi casa'
                    ),
                    draggable: true,
                  )
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
