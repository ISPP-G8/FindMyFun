import 'package:findmyfun/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/page_view_service.dart';
import '../views/event/update_event_form.dart';

class UpdateEventScreen extends StatelessWidget {
  const UpdateEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageControllerService = Provider.of<PageViewService>(context);

    return Scaffold(
        backgroundColor: ProjectColors.primary,
        body: Container(
          alignment: Alignment.center,
          // padding: const EdgeInsetsDirectional.only(top: 25.0),
          child: PageView(
            controller: pageControllerService.pageController,
            children: const [UpdateEventView()],
          ),
        ));
  }
}
