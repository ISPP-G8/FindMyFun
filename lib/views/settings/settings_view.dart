// ignore_for_file: use_build_context_synchronously

import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UsersService>(context);
    final user = userService.currentUser!;
    return Scaffold(
        // backgroundColor: ProjectColors.primary,
        body: Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'profile'),
            child: CustomButton(text: 'Mi perfil')),
        Visibility(
          visible: user.isAdmin ?? false,
          child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'users'),
              child: CustomButton(text: 'Usuarios registrados')),
        ),
        Visibility(
          visible: user.isCompany ?? false,
          child: GestureDetector(
              onTap: () async {
                await AuthService().signOut();
                Navigator.pushNamed(context, 'eventpointcreation');
              },
              child: CustomButton(text: 'Crear punto de event')),
        ),
        GestureDetector(
            onTap: () async {
              await AuthService().signOut();
              Navigator.pushReplacementNamed(context, 'login');
            },
            child: CustomButton(text: 'Cerrar sesión')),
      ],
    ));
  }
}
