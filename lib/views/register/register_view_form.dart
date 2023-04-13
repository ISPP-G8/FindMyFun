// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:findmyfun/helpers/helpers.dart';
import 'package:findmyfun/models/models.dart' as models;
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
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          const LoginTitle(text: 'REGISTRO'),
          const ImageLogo(),
          SizedBox(height: size.height * 0.05),
          const LoginContainer(
            child: _RegisterFormContainer(),
          )
        ],
      ),
    );
  }
}

class _RegisterFormContainer extends StatefulWidget {
  const _RegisterFormContainer();

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
      key: _formKey,
      child: Column(children: [
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
            if (_passwordConfirmController.text != _passwordController.text) {
              return 'Las contraseñas no coinciden.';
            }
            return null;
          },
        ),
        CustomTextForm(
          hintText: 'Ciudad',
          controller: _locationController,
          validator: (value) => Validators.validateNotEmpty(value),
        ),
        SubmitButton(
          text: 'CONTINUAR',
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              if (_passwordConfirmController.text !=
                  _passwordConfirmController.text) return;
              try {
                showDialog(
                  context: context,
                  builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator()),
                      ]),
                );
                UserCredential credential = await AuthService()
                    .createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text);

                userService.currentUser = models.User(
                    id: credential.user!.uid,
                    image: _imageController.text,
                    name: _nameController.text,
                    surname: _surnameController.text,
                    username: _usernameController.text,
                    city: _locationController.text,
                    email: _emailController.text,
                    preferences: [
                      models.Preferences(id: '0001', name: 'Preferencia')
                    ],
                    subscription: models.Subscription(
                        type: models.SubscriptionType.free,
                        numEventsCreatedThisMonth: 0));
                final resp =
                    await userService.addItem(userService.currentUser!);
                if (resp) {
                  Navigator.pop(context);
                  final pageViewService =
                      Provider.of<PageViewService>(context, listen: false);
                  pageViewService.registerPageController.animateToPage(1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                } else {
                  Navigator.pop(context);
                  _formKey.currentState!.validate();
                  print('Error al crear el usuario');
                }
                print(
                    'Usuario creado con uid: ${credential.user?.getIdToken()}');
              } on FirebaseAuthException {
                Navigator.pop(context);
                showExceptionDialog(context);
              } on FirebaseException {
                Navigator.pop(context);
                showExceptionDialog(context);
              } catch (e) {
                Navigator.pop(context);
                showExceptionDialog(context);
              }
            }
          },
        )
      ]),
    );
  }
}

showExceptionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => const AlertDialog(
      content: Text('Por favor, revisa los datos proporcionados.'),
    ),
  );
}
