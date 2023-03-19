import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/themes/colors.dart';
import 'package:findmyfun/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: ProjectColors.primary,
        body: Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'profile'),
            child: const CustomButton(text: 'Mi perfil')),
        GestureDetector(
            onTap: () async {
              await AuthService().signOut();
              Navigator.pushReplacementNamed(context, 'login');
            },
            child: const CustomButton(text: 'Cerrar sesión')),
        GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'map'),
            child: const CustomButton(text: 'Mapa')),

      ],
    ));
  }
}
