import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../helpers/validators.dart';
import '../../services/services.dart';
import '../../ui/custom_snackbars.dart';

const int maxFailedLoadAttemptsEvent = 3;

class EventCreationView extends StatelessWidget {
  const EventCreationView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          // backgroundColor: ProjectColors.primary,
          body: SingleChildScrollView(
              child: Column(children: [
            const CustomAd(),
            const Center(
                child: Text(
              'CREAR EVENTO',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            )),
            const SizedBox(
              height: 20,
            ),
            LoginContainer(
              child: _FormsColumn(),
            ),
          ]))),
    );
  }
}

// ignore: must_be_immutable
class _FormsColumn extends StatefulWidget {
  _FormsColumn();

  @override
  State<_FormsColumn> createState() => _FormsColumnState();
}

class _FormsColumnState extends State<_FormsColumn> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _city = TextEditingController();
  final _country = TextEditingController();
  final _latitude = TextEditingController();
  final _longitude = TextEditingController();
  final _description = TextEditingController();
  final _image = TextEditingController();
  final _startDateTime = TextEditingController();
  final _startTime = TextEditingController();
  List<Object> _selectedValues = [];

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
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
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
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    String? id = AuthService().currentUser?.uid ?? "";
    return Form(
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          CustomTextForm(
            hintText: 'Nombre del evento',
            controller: _name,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Lugar',
            controller: _address,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Ciudad',
            controller: _city,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'País',
            controller: _country,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Latitud',
            controller: _latitude,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Longitud',
            controller: _longitude,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Descripción',
            maxLines: 5,
            type: TextInputType.multiline,
            controller: _description,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Link de la imagen',
            controller: _image,
            validator: (value) => Validators.validateNotEmpty(value),
          ),
          CustomTextForm(
            hintText: 'Fecha: aaaa-MM-dd',
            controller: _startDateTime,
            validator: (value) => Validators.validateDate(value),
          ),
          CustomTextForm(
            hintText: 'Hora: HH:mm',
            controller: _startTime,
            validator: (value) => Validators.validateTime(value),
          ),
          CategoryDropdown(
            selectedValues: _selectedValues,
            onSelectionChanged: (selected) {
              _selectedValues = selected;
            },
          ),
          SubmitButton(
            text: 'CONTINUAR',
            onTap: () async {
              if (_formKey.currentState!.validate() &&
                  _selectedValues.isNotEmpty) {
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
                await eventsService.saveEvent(Event(
                    address: _address.text,
                    city: _city.text,
                    country: _country.text,
                    description: _description.text,
                    finished: false,
                    image: _image.text,
                    name: _name.text,
                    latitude: double.parse(_latitude.text),
                    longitude: double.parse(_longitude.text),
                    startDate: DateTime.parse(
                        '${_startDateTime.text} ${_startTime.text}'),
                    tags: await Future.wait(_selectedValues
                        .map((e) => PreferencesService()
                            .getPreferenceByName(e.toString()))
                        .toList()),
                    users: [id],
                    messages: [
                      Messages(
                          userId: "8AH3CM76DydLFLrAQANT2gTBYlk2",
                          date: DateTime.now(),
                          text: "Bienvenido")
                    ],
                    id: const Uuid().v1()));
                _showInterstitialAd();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                final pageController =
                    // ignore: use_build_context_synchronously
                    Provider.of<PageViewService>(context, listen: false);
                pageController.mainPageController.jumpToPage(0);
              } else {
                CustomSnackbars.showCustomSnackbar(
                  context,
                  const Text('Rellene los campos'),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
