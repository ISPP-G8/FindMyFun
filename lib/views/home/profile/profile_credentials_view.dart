// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/models/models.dart' as user;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../helpers/validators.dart';
import '../../../services/services.dart';
import '../../../themes/colors.dart';
// ignore: unused_import
import '../../../themes/styles.dart';
import '../../../widgets/widgets.dart';

class ProfileCredentialsForm extends StatelessWidget {
  const ProfileCredentialsForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProjectColors.primary,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.chevron_left,
              size: 45,
              color: Color.fromARGB(255, 161, 154, 154),
            )),
        elevation: 0,
        centerTitle: true,
        title: const AutoSizeText(
          'CAMBIAR CONTRASEÑA',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Color(0xff828a92),
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: Center(
        child: Container(
          height: 800,
          width: 400,
          decoration: const BoxDecoration(
            color: Color(0xff828a92),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: const [
                LoginContainer(
                  child: _ProfileCredentialsForm(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileCredentialsForm extends StatefulWidget {
  const _ProfileCredentialsForm();

  @override
  State<_ProfileCredentialsForm> createState() =>
      _ProfileCredentialsFormState();
}

class _ProfileCredentialsFormState extends State<_ProfileCredentialsForm> {
  final _passwordController = TextEditingController();
  final _passwordNewController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UsersService>(context);
    final currentUser = userService.currentUser!;
    // final authService = Provider.of<AuthService>(context);

    return Form(
      key: _formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            padding: const EdgeInsets.all(10.0), child: userImage(currentUser)),
        const Text(
          "Correo electrónico",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        CustomTextForm(
          hintText: currentUser.email,
          controller: _emailController,
          validator: (value) =>
              Validators.validateCurrentEmail(value, currentUser.email),
        ),
        const Text(
          "Contraseña actual",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        CustomTextForm(
          hintText: "",
          controller: _passwordController,
          obscure: true,
          validator: (value) => Validators.validatePassword(value),
        ),
        const Text(
          "Nueva contraseña",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        CustomTextForm(
          hintText: "",
          controller: _passwordNewController,
          obscure: true,
          validator: (value) => Validators.validatePassword(value),
        ),
        const Text(
          "Confirme la nueva contraseña",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        CustomTextForm(
          hintText: '',
          controller: _passwordConfirmController,
          obscure: true,
          validator: (value) {
            if (_passwordConfirmController.text !=
                _passwordNewController.text) {
              return 'Las contraseñas no coinciden.';
            }
            return null;
          },
        ),
        SubmitButton(
          text: 'CAMBIAR CONTRASEÑA',
          onTap: () async {
            if (_formKey.currentState!.validate()) {
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
                final resp = await AuthService().updatePassword(
                    _emailController.text,
                    _passwordController.text,
                    _passwordNewController.text);

                await Future.delayed(
                  const Duration(seconds: 3),
                );
                if (resp) {
                  print(
                      'Credenciales modificadas del usuario con uid: ${currentUser.id}');
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Cambio de contraseña.'),
                        content: const Text(
                            'El cambio de contraseña se ha realizado con éxito.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Navigator.pop(context);
                  _formKey.currentState!.validate();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error al cambiar la contraseña'),
                        content: const Text(
                            'Comprueba que has introducido bien la dirección de correo y las contraseñas e inténtelo de nuevo.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                  print('Error al cambiar las credenciales');
                }
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

// impor

Widget userImage(user.User user) {
  // En chrome puede que de error y se muestre el icono pero en móvil va bien

  if (user.image == null || user.image!.isEmpty) {
    return const Icon(
      Icons.account_circle,
      size: 150,
    );
  }

  try {
    return CircleAvatar(
        radius: 120,
        backgroundImage: const AssetImage('assets/placeholder.png'),
        child: ClipOval(
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            height: 300,
            placeholder: (context, url) =>
                Image.asset('assets/placeholder.png'),
            imageUrl: user.image!,
            errorWidget: (context, url, error) {
              print('Error al obtener la imagen: $error');

              return const Icon(
                Icons.account_circle,
                size: 150,
              );
            },
          ),
        ));
  } catch (e) {
    return const Icon(
      Icons.account_circle,
      size: 150,
    );
  }
}
