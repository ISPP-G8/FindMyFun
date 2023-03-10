import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/event.dart';
import '../../services/services.dart';
import '../../widgets/widgets.dart';

class AccessView extends StatelessWidget {
  const AccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final pageControllerService = Provider.of<PageViewService>(context);
    final size = MediaQuery.of(context).size;

    final Event e = Event(
        id: "10",
        address: "Larios",
        city: "Malaga",
        country: "España",
        creator: "Daniel",
        description: "El mejor lugar",
        image:
            "https://img.freepik.com/foto-gratis/playa-tropical_74190-188.jpg?w=2000",
        name: "EventoMalaga",
        startDate: DateTime.now(),
        tags: []);

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: size.height),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,

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
                onTap: () => pageControllerService.pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut)),
            CustomButton(
                text: 'Acceder como usuario',
                onTap: () => pageControllerService.pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut)),
            CustomButton(
              text: "hola",
              onTap: () => Navigator.pushNamed(context, "Update", arguments: e),
            )

            // const SizedBox(
            //   height: 100,
            // )
          ],
        ),
      ),
    );
  }
}
