import 'package:findmyfun/themes/colors.dart';
import 'package:findmyfun/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: ProjectColors.primary,
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'profile'),
              child: CustomButton(text: 'Mi perfil')),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'preferences'),
              child: CustomButton(text: 'Preferencias'))
          ],
        ));
  }
}
