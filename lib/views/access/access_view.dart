import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';
import '../../widgets/widgets.dart';

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
            SizedBox(
              height: size.height * 0.15,
            ),
            const ImageLogo(),
            const ImageBanner(),
            SizedBox(height: size.height * 0.12),
            CustomButton(
              text: 'Acceder como empresa',
              onTap: () => pageControllerService.pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut),
            ),
            SizedBox(height: size.height * 0.03),
            CustomButton(
              text: 'Acceder como usuario',
              onTap: () => pageControllerService.pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut),
            ),
          ],
        ),
      ),
    );
  }
}
