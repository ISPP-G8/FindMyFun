import 'package:findmyfun/screens/screens.dart';
import 'package:findmyfun/services/page_view_service.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../views/views.dart';

class AccessScreen extends StatelessWidget {
  const AccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageControllerService = Provider.of<PageViewService>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: ProjectColors.primary,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final UsersService usersService =
                Provider.of<UsersService>(context, listen: false);
            User user = await usersService.getUserWithUid("37486");
            final EventsService eventsService =
                Provider.of<EventsService>(context, listen: false);
            await eventsService.getEvents();
            eventsService.addUser(eventsService.events[0], user);
          },
        ),
        body: Container(
          alignment: Alignment.center,
          child: PageView(
              controller: pageControllerService.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                AccessView(),
                LoginView(),
                ProfileDetailsView(),
                PreferencesView()
              ]),
        ));
  }
}
