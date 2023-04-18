// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/helpers/helpers.dart';
import 'package:findmyfun/models/models.dart' as user;
import 'package:findmyfun/ui/show_circular_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/services.dart';
import '../../../themes/colors.dart';
import '../../../themes/styles.dart';
import '../../../widgets/widgets.dart';

class ProfileEditForm extends StatelessWidget {
  const ProfileEditForm({
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
        title: Text(
          'EDITAR PERFIL',
          textAlign: TextAlign.center,
          style: Styles.appBar,
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
                  child: _ProfileEditForm(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileEditForm extends StatefulWidget {
  const _ProfileEditForm();

  @override
  State<_ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<_ProfileEditForm> {
  final _imageController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String imagePath = '';

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UsersService>(context);
    final currentUser = userService.currentUser!;

    if (currentUser.image != null && currentUser.image!.isNotEmpty) {
      imagePath = currentUser.image!;
    }

    return Form(
      key: _formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            margin: const EdgeInsets.all(10), child: circleImage(imagePath)),
        const Text(
          "Nombre de usuario",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        CustomTextForm(
          hintText: currentUser.username,
          controller: _usernameController,
        ),
        const Text(
          "Nombre",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        CustomTextForm(
          hintText: currentUser.name,
          controller: _nameController,
        ),
        const Text(
          "Apellidos",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        CustomTextForm(
          hintText: currentUser.surname,
          controller: _surnameController,
        ),
        const Text(
          "Ciudad",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        CustomTextForm(
          hintText: currentUser.city,
          controller: _cityController,
        ),
        const Text(
          "Imagen de perfil",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        GestureDetector(
          onTap: () async {
            showCircularProgressDialog(context);
            imagePath = await uploadImage(context,
                route: 'Users/${currentUser.id}',
                imageId: '${currentUser.id}_profile_image');
            Navigator.pop(context);
            currentUser.image = imagePath;
            setState(() {});
          },
          child: CustomTextForm(
            enabled: false,
            maxLines: 2,
            hintText: 'Pulsa aquí para seleccionar la imagen',
          ),
        ),
        SubmitButton(
          text: 'MODIFICAR',
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              // try {
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

              if (_usernameController.text == "") {
                _usernameController.text = currentUser.username;
              }
              if (_nameController.text == "") {
                _nameController.text = currentUser.name;
              }
              if (_surnameController.text == "") {
                _surnameController.text = currentUser.surname;
              }
              if (_cityController.text == "") {
                _cityController.text = currentUser.city;
              }
              if (_imageController.text == "") {
                _imageController.text = currentUser.image!;
              }
              userService.currentUser = user.User(
                  id: currentUser.id,
                  image: imagePath,
                  name: _nameController.text,
                  surname: _surnameController.text,
                  username: _usernameController.text,
                  city: _cityController.text,
                  email: currentUser.email,
                  preferences: currentUser.preferences,
                  notifications: currentUser.notifications,
                  subscription: currentUser.subscription);
              final resp = await userService
                  .updateProfileAdmin(userService.currentUser!);
              if (resp) {
                print(_nameController.text);
                Navigator.pop(context);
                Navigator.pop(context);
                Provider.of<PageViewService>(context, listen: false)
                    .mainPageController
                    .jumpToPage(0);
              } else {
                Navigator.pop(context);
                _formKey.currentState!.validate();
                print('Error al editar el usuario');
              }
              print('Usuario modificado con uid: ${currentUser.id}');
              // } on FirebaseAuthException {
              //   Navigator.pop(context);
              //   showExceptionDialog(context);
              // } on FirebaseException {
              //   Navigator.pop(context);
              //   showExceptionDialog(context);
              // } catch (e) {
              //   Navigator.pop(context);
              //   showExceptionDialog(context);
              // }
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


