import 'package:flutter/material.dart';

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
    return const Column(children: [
      CustomTextForm(hintText: 'Nombre'),
      CustomTextForm(hintText: 'Apellidos'),
      CustomTextForm(hintText: 'Mail'),
      CustomTextForm(hintText: 'Nombre de usuario'),
      CustomTextForm(
        hintText: 'Contraseña',
        obscure: true,
      ),
      CustomTextForm(
        hintText: 'Repetir contraseña',
        obscure: true,
      ),
      CustomTextForm(hintText: 'Localización'),
      SubmitButton(text: 'CONTINUAR')
    ]);
  }
}
