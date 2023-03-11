import 'package:findmyfun/helpers/helpers.dart';
import 'package:findmyfun/models/models.dart' as user;
import 'package:firebase_auth/firebase_auth.dart';
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
    return SingleChildScrollView(
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

class _RegisterFormContainer extends StatefulWidget {
  const _RegisterFormContainer({
    super.key,
  });

  @override
  State<_RegisterFormContainer> createState() => _RegisterFormContainerState();
}

class _RegisterFormContainerState extends State<_RegisterFormContainer> {
  final _imageController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _locationController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UsersService>(context);
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: _formKey,
      child: Column(children: [
        CustomTextForm(
            hintText: 'Imagen',
            controller: _imageController,
            validator: (value) => Validators.validateNotEmpty(value)),
        CustomTextForm(
          hintText: 'Nombre',
          controller: _nameController,
          validator: (value) => Validators.validateNotEmpty(value),
        ),
        CustomTextForm(
          hintText: 'Apellidos',
          controller: _surnameController,
          validator: (value) => Validators.validateNotEmpty(value),
        ),
        CustomTextForm(
          hintText: 'Mail',
          controller: _emailController,
          validator: (value) => Validators.validateEmail(value),
        ),
        CustomTextForm(
          hintText: 'Nombre de usuario',
          controller: _usernameController,
          validator: (value) => Validators.validateNotEmpty(value),
        ),
        CustomTextForm(
          hintText: 'Contraseña',
          controller: _passwordController,
          obscure: true,
          validator: (value) => Validators.validatePassword(value),
        ),
        CustomTextForm(
          hintText: 'Repetir contraseña',
          obscure: true,
          controller: _passwordConfirmController,
          validator: (value) {
            if (_passwordConfirmController.text != _passwordController.text)
              return 'Las contraseñas no coinciden.';
            return null;
          },
        ),
        CustomTextForm(
          hintText: 'Localización',
          controller: _locationController,
          validator: (value) => Validators.validateNotEmpty(value),
        ),
        SubmitButton(
          text: 'CONTINUAR',
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              if (_passwordConfirmController.text !=
                  _passwordConfirmController.text) return;
              UserCredential credential = await AuthService()
                  .createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text);
              userService.currentUser = user.User(
                  id: credential.user!.uid,
                  image: _imageController.text,
                  name: _nameController.text,
                  surname: _surnameController.text,
                  username: _usernameController.text,
                  city: _locationController.text,
                  email: _emailController.text,
                  preferences: []);
              print(credential.user?.getIdToken());
              final pageViewService =
                  Provider.of<PageViewService>(context, listen: false);
              pageViewService.registerPageController.animateToPage(1,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut);
            }
          },
        )
      ]),
    );
  }
}
