import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../views/views.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

int cont = 0;

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    final eventsService = Provider.of<EventsService>(context, listen: false);

    Future.delayed(Duration.zero, () async {
      // Pobla la lista de eventos del servicio
      await eventsService.getEvents();
      await eventsService.findEvents();
    });
    final preferencesService =
        Provider.of<PreferencesService>(context, listen: false);
    if (cont == 0) {
      Future.delayed(
          Duration.zero, () async => await preferencesService.getPreferences());
      cont++;
    }
    Future.delayed(Duration.zero,
        () async => await preferencesService.getPreferencesByUserId());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageControllerService = Provider.of<PageViewService>(context);

    return Scaffold(
        // backgroundColor: ProjectColors.primary,
        bottomNavigationBar: const CustomNavigationBar(),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        // ),
        appBar: AppBar(
          backgroundColor: ProjectColors.tertiary,
          elevation: 0,
          leading: Image.asset('assets/logo.png'),
          centerTitle: true,
          title: SizedBox(
              height: 50, child: Image.asset('assets/logo-banner.png')),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(
                  Icons.exit_to_app,
                  size: 50,
                ),
                onPressed: () async {
                  await AuthService().signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, 'access');
                },
              ),
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: PageView(
              controller: pageControllerService.mainPageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                EventListView(),
                EventFindView(),
                EventCreationView(),
                EventSearchView(),
                ProfileDetailsView(),
                SettingsView()
              ]),
        ));
  }
}
