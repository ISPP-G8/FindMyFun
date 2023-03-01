import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/services.dart';
import '../../widgets/widgets.dart';

class RegisterViewForm extends StatelessWidget {
  const RegisterViewForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          LoginTitle(text: 'REGISTRO'),
          ImageLogo(),
          LoginContainer(
            child: _RegisterFormContainer(),
          )
        ],
      ),
    );
  }
}

class _RegisterFormContainer extends StatelessWidget {
  const _RegisterFormContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(children: [
      const CustomTextForm(hintText: 'Nombre'),
      const CustomTextForm(hintText: 'Apellidos'),
      const CustomTextForm(hintText: 'Mail'),
      const CustomTextForm(hintText: 'Nombre de usuario'),
      const CustomTextForm(
        hintText: 'Contraseña',
        obscure: true,
      ),
      const CustomTextForm(
        hintText: 'Repetir contraseña',
        obscure: true,
      ),
      const CustomTextForm(hintText: 'Localización'),
      SubmitButton(text: 'CONTINUAR', onTap: () {
        final pageViewService = Provider.of<PageViewService>(context, listen: false);
        pageViewService.registerPageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
        
      },)
    ]);
  }
}
