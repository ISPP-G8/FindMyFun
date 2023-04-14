// ignore_for_file: prefer_typing_uninitialized_variables, unused_field, library_private_types_in_public_api

import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';

import '../../helpers/validators.dart';
import '../../services/services.dart';
import '../../ui/custom_snackbars.dart';

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
    User user = await UsersService()
        .getUserWithUid(AuthService().currentUser?.uid ?? "");
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
            const CustomAd(),
            const Center(
                child: Text(
              'CREAR EVENTO',
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
                    return const Center(
                      child: Text('Ya no puedes crear más eventos este mes'),
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
          Divider(
            thickness: 5,
            color: ProjectColors.secondary,
            indent: size.height * 0.05,
            endIndent: size.height * 0.05,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: size.height * 0.5, maxWidth: size.width),
            child: const MapPlaceSelectorEventScreen(),
          ),
          Divider(
            thickness: 5,
            color: ProjectColors.secondary,
            indent: size.height * 0.05,
            endIndent: size.height * 0.05,
          ),
          const Text(
            "Link de la imagen",
            textAlign: TextAlign.center,
          ),
          CustomTextForm(
            hintText: 'Link de la imagen',
            controller: _image,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          DateTimePicker(
            selectedDateTime: _selectedDatetime,
            onChanged: (selected) {
              _selectedDatetime = selected;
            },
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
                  await eventsService.saveEvent(Event(
                      address: placeMark.street!,
                      city: placeMark.locality!,
                      country: placeMark.country!,
                      description: _description.text,
                      finished: false,
                      image: _image.text,
                      name: _name.text,
                      latitude: selectedMarker.position.latitude,
                      longitude: selectedMarker.position.longitude,
                      startDate: DateTime.parse(_selectedDatetime!),
                      tags: await Future.wait(_selectedValues
                          .map((e) => PreferencesService()
                              .getPreferenceByName(e.toString()))
                          .toList()),
                      users: [id],
                      maxUsers: loggedUser.subscription.maxUsersPerEvent,
                      messages: [
                        Messages(
                            userId: "8AH3CM76DydLFLrAQANT2gTBYlk2",
                            date: DateTime.now(),
                            text: "Bienvenido")
                      ],
                      id: const Uuid().v1()));

                  loggedUser.subscription.numEventsCreatedThisMonth++;
                  UsersService().updateProfile(loggedUser);

                  _showInterstitialAd();

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
          markers: Set.from(tappedMarkerEvent),
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
      tappedMarkerEvent.clear();
      tappedMarkerEvent.add(Marker(
          markerId: MarkerId(tappedPoint.toString()), position: tappedPoint));
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
