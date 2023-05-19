// ignore_for_file: prefer_typing_uninitialized_variables, unused_field, library_private_types_in_public_api

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/helpers/helpers.dart';
import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../services/services.dart';
import '../../ui/ui.dart';

const int maxFailedLoadAttemptsEvent = 3;
List<Marker> tappedMarkerEvent = [];

late Future<User> loggedUserFuture;
late User loggedUser;

class EventCreationView extends StatefulWidget {
  const EventCreationView({super.key});

  @override
  State<StatefulWidget> createState() => _EventCreationView();
}

class _EventCreationView extends State<EventCreationView> {
  @override
  void initState() {
    super.initState();

    loggedUserFuture = getLoggedUser();
  }

  Future<User> getLoggedUser() async {
    User user = await UsersService().getCurrentUserWithUid();
    return user;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              child: Column(children: [
            SizedBox(height: size.height * 0.005),
            const AdPlanLoader(),
            const Center(
                child: AutoSizeText(
              'CREAR EVENTO',
              maxLines: 1,
              style: TextStyle(
                  color: Colors.black38,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<dynamic>(
              future: loggedUserFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  loggedUser = snapshot.data;

                  if (loggedUser.subscription.canCreateEvents) {
                    return const LoginContainer(
                      child: _FormsColumn(),
                    );
                  } else {
                    return SizedBox(
                        height: size.height * 0.6,
                        width: size.width * 0.8,
                        child: const Center(
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                  'Ya no puedes crear más eventos este mes',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: ProjectColors.tertiary,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))),
                        ));
                  }
                } else {
                  return Column(children: const [
                    SizedBox(height: 100),
                    Center(child: CircularProgressIndicator())
                  ]);
                }
              },
            ),
          ]))),
    );
  }
}

// ignore: must_be_immutable
class _FormsColumn extends StatefulWidget {
  const _FormsColumn();

  @override
  State<_FormsColumn> createState() => _FormsColumnState();
}

class _FormsColumnState extends State<_FormsColumn> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _image = TextEditingController();
  List<Object> _selectedValues = [];
  String? _selectedDatetime;

  String imagePath = '';

  InterstitialAd? _interstitialAd;
  static const AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );
  int _numInterstitialLoadAttempts = 0;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdService.interstitialAdUnitId!,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            debugPrint('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttemptsEvent) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      debugPrint('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          debugPrint('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        debugPrint('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String? id = AuthService().currentUser?.uid ?? "";
    String eventId = const Uuid().v1();
    final usersService = Provider.of<UsersService>(context);
    return Form(
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "Nombre del evento",
            textAlign: TextAlign.center,
          ),
          CustomTextForm(
            hintText: 'Nombre del evento',
            controller: _name,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          const Text(
            "Descripción",
            textAlign: TextAlign.center,
          ),
          CustomTextForm(
            hintText: 'Descripción',
            maxLines: 5,
            type: TextInputType.multiline,
            controller: _description,
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
            "Selecciona un lugar en el mapa...",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: size.height * 0.6, maxWidth: size.width),
            child: const MapPlaceSelectorEventScreen(),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            height: 20,
            indent: 20,
            endIndent: 20,
          ),
          const Text(
            "Imagen",
            textAlign: TextAlign.center,
          ),
          GestureDetector(
            onTap: () async {
              showCircularProgressDialog(context);

              imagePath = await uploadImage(context,
                  route: 'Events/$eventId', imageId: 'event_image');
              // ignore: use_build_context_synchronously
              Navigator.pop(context);

              setState(() {});
            },
            child: const CustomTextForm(
              enabled: false,
              hintText: 'Pulsa aquí para seleccionar la imagen',
              maxLines: 2,
            ),
          ),
          imagePath.isNotEmpty
              ? Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    fit: BoxFit.cover,
                    width: 400,
                    height: 250,
                    progressIndicatorBuilder: (context, url, progress) =>
                        CircularProgressIndicator(
                      value: progress.downloaded.toDouble(),
                    ),
                  ),
                )
              : Container(),
          DateTimePicker(
            selectedDateTime: _selectedDatetime,
            onChanged: (selected) {
              _selectedDatetime = selected;
            },
            validator: (value) => Validators.validateDateTimeRange(
                _selectedDatetime,
                loggedUser.subscription.maxTimeInAdvanceToCreateEventsInDays),
          ),
          const Text(
            "Categorías",
            textAlign: TextAlign.center,
          ),
          CategoryDropdown(
            selectedValues: _selectedValues,
            onSelectionChanged: (selected) {
              _selectedValues = selected;
            },
          ),
          SubmitButton(
            margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            text: 'Crear',
            onTap: () async {
              if (_formKey.currentState!.validate() &&
                  _selectedValues.isNotEmpty &&
                  _selectedDatetime != null) {
                showDialog(
                  context: context,
                  builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()),
                      ]),
                );
                final eventsService =
                    Provider.of<EventsService>(context, listen: false);

                Marker selectedMarker = tappedMarkerEvent[0];

                List<Placemark> selectedPlaceMark =
                    await placemarkFromCoordinates(
                        selectedMarker.position.latitude,
                        selectedMarker.position.longitude);

                Placemark placeMark = selectedPlaceMark[0];

                if (loggedUser.subscription.canCreateEvents) {
                  final event = Event(
                      address: placeMark.street!,
                      city: placeMark.locality!,
                      country: placeMark.country!,
                      description: _description.text,
                      image: imagePath,
                      name: _name.text,
                      latitude: selectedMarker.position.latitude,
                      longitude: selectedMarker.position.longitude,
                      startDate: DateTime.parse(_selectedDatetime!),
                      visibleFrom:
                          loggedUser.subscription.maxVisiblityOfEventsInDays ==
                                  -1
                              ? DateTime.fromMillisecondsSinceEpoch(0)
                              : DateTime.parse(_selectedDatetime!).subtract(
                                  Duration(
                                      days: loggedUser.subscription
                                          .maxVisiblityOfEventsInDays)),
                      tags: await Future.wait(_selectedValues
                          .map((e) => PreferencesService()
                              .getPreferenceByName(e.toString()))
                          .toList()),
                      users: [id],
                      maxUsers: loggedUser.subscription.maxUsersPerEvent,
                      messages: [
                        Messages(
                            userId: loggedUser.id,
                            date: DateTime.now(),
                            text: "Bienvenido")
                      ],
                      id: eventId);

                  // ignore: use_build_context_synchronously
                  await eventsService.saveEvent(context, event);
                  final notificationCreacionEvento = ImportantNotification(
                      userId: event.creator,
                      date: DateTime.now(),
                      info: "Has creado correctamente el evento ${event.name}");

                  loggedUser.notifications.add(notificationCreacionEvento);
                  loggedUser.subscription.numEventsCreatedThisMonth++;
                  await usersService.updateUser(loggedUser);

                  if (loggedUser.subscription.type == SubscriptionType.free) {
                    _showInterstitialAd();
                  }

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  final pageController =
                      // ignore: use_build_context_synchronously
                      Provider.of<PageViewService>(context, listen: false);
                  pageController.mainPageController.jumpToPage(0);
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  CustomSnackbars.showCustomSnackbar(
                    context,
                    const Text('Ya no puedes crear más eventos este mes'),
                  );
                }
              } else {
                CustomSnackbars.showCustomSnackbar(
                  context,
                  const Text('Asegúrese de rellenar todos los campos'),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class MapPlaceSelectorEventScreen extends StatefulWidget {
  const MapPlaceSelectorEventScreen({super.key});

  @override
  State<MapPlaceSelectorEventScreen> createState() =>
      _MapPlaceSelectorEventScreen();
}

class _MapPlaceSelectorEventScreen extends State<MapPlaceSelectorEventScreen> {
  late GoogleMapController _googleMapController;
  String? selectedEventPointPosition;

  late Future eventsAndEventsPoints;

  @override
  void initState() {
    super.initState();

    eventsAndEventsPoints = _getMarkers();
  }

  _getMarkers() async {
    MapService mapService = MapService();
    bool isEventCreation = true;
    return await mapService.getMarkers(isEventCreation);
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(37.356342, -5.984759),
    zoom: 13,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        // ignore: sized_box_for_whitespace
        Container(
          height: size.height * 0.49,
          child: Stack(
            alignment: Alignment.center,
            children: [
              FutureBuilder<dynamic>(
                future: eventsAndEventsPoints,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Point> points = snapshot.data!;
                    return GoogleMap(
                      initialCameraPosition: _initialCameraPosition,
                      onMapCreated: (controller) =>
                          _googleMapController = controller,
                      markers: Set.from(tappedMarkerEvent +
                          points.map((p) => p.marker).toList()),
                      onTap: _handleTapMarker,
                      mapType: MapType.normal,
                      gestureRecognizers: {
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                    );
                  } else {
                    return Column(children: const [
                      SizedBox(height: 100),
                      Center(child: CircularProgressIndicator())
                    ]);
                  }
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    color: ProjectColors.primary.withOpacity(0.7),
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.001,
                        horizontal: size.width * 0.01),
                    height: size.height * 0.1,
                    width: size.width * 0.35,
                    child: Column(
                      children: [
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            Container(
                              color: Colors.orange,
                              height: 10,
                              width: 10,
                            ),
                            const AutoSizeText(" Tu evento",
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  decoration: TextDecoration.none,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              color: Colors.pink,
                              height: 10,
                              width: 10,
                            ),
                            const AutoSizeText(" Tus eventos",
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  decoration: TextDecoration.none,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              color: Colors.red,
                              height: 10,
                              width: 10,
                            ),
                            const AutoSizeText(" Otros eventos",
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  decoration: TextDecoration.none,
                                )),
                          ],
                        ),
                        SizedBox(height: size.height * 0.001),
                        Row(
                          children: [
                            Container(
                              color: Colors.purple,
                              height: 10,
                              width: 10,
                            ),
                            const AutoSizeText(" Puntos de evento",
                                maxLines: 1,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  decoration: TextDecoration.none,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        const Text(
          "...O un punto de evento",
          textAlign: TextAlign.center,
        ),
        EventPointsDropdown(
          selectedValue: selectedEventPointPosition,
          onSelectionChanged: (selected) {
            double latitude = double.parse(selected.split(",")[0]);
            double longitude = double.parse(selected.split(",")[1]);
            LatLng position = LatLng(latitude, longitude);
            _handleTapMarker(position);
          },
        ),
      ],
    );
  }

  _handleTapMarker(LatLng tappedPoint) {
    setState(() {
      tappedMarkerEvent.clear();
      tappedMarkerEvent.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange)));
    });
  }
}

class DateTimePicker extends StatefulWidget {
  final String? selectedDateTime;
  final Function(String) onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  const DateTimePicker(
      {super.key,
      this.selectedDateTime,
      required this.onChanged,
      this.controller,
      this.validator});

  @override
  _DateTimePicker createState() => _DateTimePicker();
}

class _DateTimePicker extends State<DateTimePicker> {
  var _currentSelectedDate;
  var _currentSelectedTime;
  String? _currentSelectedDateTime;

  void callDatePicker() async {
    var selectedDate = await getDatePickerWidget();
    setState(() {
      _currentSelectedDate = selectedDate;
      _currentSelectedDateTime =
          "${selectedDate.toString().split(" ").first} ${_currentSelectedTime.toString().split("(").last.replaceAll(")", "")}";
      widget.onChanged(_currentSelectedDateTime!);
    });
  }

  Future<DateTime?> getDatePickerWidget() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );
  }

  void callTimePicker() async {
    var selectedTime = await getTimePickerWidget();
    setState(() {
      _currentSelectedTime = selectedTime;
      _currentSelectedDateTime =
          "${_currentSelectedDate.toString().split(" ").first} ${selectedTime.toString().split("(").last.replaceAll(")", "")}";
      widget.onChanged(_currentSelectedDateTime!);
    });
  }

  Future<TimeOfDay?> getTimePickerWidget() {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic displayedSelectedDate = _currentSelectedDate ?? " ";
    dynamic displayedSelectedTime = _currentSelectedTime ?? " ";
    dynamic displayedCompleteDateTime =
        "${displayedSelectedDate.toString().split(" ").first} ${displayedSelectedTime.toString().split("(").last.replaceAll(")", "")}";
    // _displayedSelectedDate + DateTime.parse(_displayedSelectedTime);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DatePickerButton(
              onTap: () {
                callDatePicker();
                setState(() {
                  displayedCompleteDateTime =
                      "${displayedSelectedDate.toString().split(" ").first} ${displayedSelectedTime.toString().split("(").last.replaceAll(")", "")}";
                  widget.onChanged(displayedCompleteDateTime);
                });
              },
              text: 'Seleccionar fecha',
            ),
            DatePickerButton(
              onTap: () {
                callTimePicker();
              },
              text: 'Seleccionar hora',
            )
          ],
        ),
        CustomTextForm(
          hintText: "$displayedCompleteDateTime",
          enabled: false,
          controller: widget.controller,
          validator: widget.validator,
        )
      ],
    );
  }
}

class DatePickerButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final double? width;

  const DatePickerButton(
      {super.key,
      required this.text,
      this.onTap,
      this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.4,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 127, 122, 122),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
