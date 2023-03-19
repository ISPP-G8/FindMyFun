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
              color: Colors.black,
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
    zoom: 11.5,
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

    final Marker _marker = Marker(
      markerId: const MarkerId('Casa Juanma'), 
      position: const LatLng(37.357937, -5.978426), 
      onTap: () => Navigator.pushNamed(context, 'main'),
    );
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            markers: {_marker},
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => _googleMapController = controller,
            mapType: MapType.terrain,
          ),
        ],
      ),
    );
  }
}
