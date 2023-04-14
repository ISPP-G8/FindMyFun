import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/helpers/helpers.dart';
import 'package:findmyfun/models/event_point.dart';
import 'package:findmyfun/services/important_notification_service.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/ui/ui.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/models.dart';
import '../services/services.dart';

const int maxFailedLoadAttemptsEventPoint = 3;
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

  InterstitialAd? _interstitialAd;
  static const AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );
  int _numInterstitialLoadAttempts = 0;

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
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdService.interstitialAdUnitId!,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <
                maxFailedLoadAttemptsEventPoint) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final eventPointsService = Provider.of<EventPointsService>(context);
    final notificationService =
        Provider.of<ImportantNotificationService>(context);
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
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: size.height),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const CustomAd(),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      height: 20,
                      indent: 20,
                      endIndent: 20,
                    ),
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
                      thickness: 5,
                      color: ProjectColors.secondary,
                      indent: size.height * 0.05,
                      endIndent: size.height * 0.05,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: size.height * 0.5, maxWidth: size.width),
                      child: const MapPlaceSelectorEventPointScreen(),
                    ),
                    Divider(
                      thickness: 5,
                      color: ProjectColors.secondary,
                      indent: size.height * 0.05,
                      endIndent: size.height * 0.05,
                    ),
                    const Text(
                      "Nombre del punto de evento",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    CustomTextForm(
                      hintText: 'Nombre',
                      controller: _nameController,
                      validator: (value) => Validators.validateNotEmpty(value),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      height: 20,
                      indent: 20,
                      endIndent: 20,
                    ),
                    const Text(
                      "Descripción",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    CustomTextForm(
                      hintText: 'Descripción',
                      maxLines: 8,
                      controller: _descriptionController,
                      validator: (value) => Validators.validateNotEmpty(value),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 0.5,
                      height: 20,
                      indent: 20,
                      endIndent: 20,
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
                                final notification = ImportantNotification(
                                    userId: AuthService().currentUser!.uid,
                                    date: DateTime.now(),
                                    info:
                                        "Has creado correctamente el punto de evento ${eventPoint.name}");
                                notificationService.saveNotification(
                                    context,
                                    notification,
                                    AuthService().currentUser!.uid);

                                _showInterstitialAd();

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
