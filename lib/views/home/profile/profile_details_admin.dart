// ignore_for_file: use_build_context_synchronously

import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/themes/styles.dart';
import 'package:findmyfun/widgets/custom_banner_ad.dart';
import 'package:findmyfun/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/services/services.dart';

import '../../../widgets/custom_button.dart';

class ProfileDetailsAdmin extends StatelessWidget {
  const ProfileDetailsAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedUser = ModalRoute.of(context)!.settings.arguments as User;

    final userService = Provider.of<UsersService>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'MI PERFIL',
          textAlign: TextAlign.center,
          style: Styles.appBar,
        ),
      ),
      body: Center(
        child: SizedBox(
          height: 1000,
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomAd(width: size.width.floor()),
                Container(
                    padding: const EdgeInsets.all(10.0),
                    // child: Image.network(selectedUser.image!, fit: BoxFit.cover),
                    child: userImage(selectedUser)),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                const Text(
                  "Nombre del usuario",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextForm(
                  hintText: selectedUser.username,
                  initialValue: selectedUser.username,
                  enabled: false,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                const Text(
                  "Nombre",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextForm(
                  hintText: selectedUser.name,
                  initialValue: selectedUser.name,
                  enabled: false,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                const Text(
                  "Apellidos",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextForm(
                  hintText: selectedUser.surname,
                  initialValue: selectedUser.surname,
                  enabled: false,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                const Text(
                  "Ciudad",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextForm(
                  hintText: selectedUser.city,
                  initialValue: selectedUser.city,
                  enabled: false,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                const Text(
                  "Email",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
                CustomTextForm(
                  hintText: selectedUser.email,
                  initialValue: selectedUser.email,
                  enabled: false,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, 'editProfileAdmin',
                        arguments: selectedUser),
                    child: const CustomButton(text: 'Editar perfil')),
                GestureDetector(
                    onTap: () =>
                        userService.deleteProfile(selectedUser, context),
                    child: const CustomButton(text: 'Borrar perfil')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget userImage(User user) {
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
              // ignore: avoid_print
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

// Importa los paquetes necesarios

// Define un StatefulWidget
class DeleteProfile extends StatefulWidget {
  const DeleteProfile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeleteProfile createState() => _DeleteProfile();
}

class _DeleteProfile extends State<DeleteProfile> {
  @override
  Widget build(BuildContext context) {
    final selectedUser = ModalRoute.of(context)!.settings.arguments as User;

    final userService = Provider.of<UsersService>(context);

    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 128, 13, 5))),
      child: const Text('Eliminar cuenta'),
      onPressed: () {
        // Muestra el pop-up al pulsar el botón
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmación'),
              content: const Text(
                  '¿Estás seguro de que quieres eliminar tu cuenta?'),
              actions: [
                TextButton(
                  child: const Text('Mejor me quedo'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Si, estoy seguro'),
                  onPressed: () {
                    UsersService().deleteProfile(selectedUser,
                        context); // Agrega aquí el código que se ejecutará al confirmar
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
