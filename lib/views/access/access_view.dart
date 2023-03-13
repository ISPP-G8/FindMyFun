import 'package:findmyfun/views/event/event_creation_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';
import '../../widgets/widgets.dart';
import '../event/event_details.dart';
import '../home/events/event_list_view.dart';

class AccessView extends StatelessWidget {
  const AccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageControllerService = Provider.of<PageViewService>(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: size.height),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            const ImageLogo(),
            const ImageBanner(),
            const SizedBox(
              height: 100,
            ),
            CustomButton(
              text: 'Acceder como empresa',
              onTap: () => pageControllerService.pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut),
            ),
            CustomButton(
              text: 'Acceder como usuario',
              onTap: () => pageControllerService.pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut),
            ),          ],
        ),
      ),
    );
  }
}
