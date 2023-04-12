import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/users_service.dart';
import 'package:findmyfun/themes/styles.dart';
import 'package:findmyfun/widgets/custom_banner_ad.dart';
import 'package:findmyfun/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../widgets/custom_button.dart';

class ProfileDetailsView extends StatelessWidget {
  const ProfileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UsersService>(context);
    final currentUser = userService.currentUser!;
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
        child: Container(
          height: 1000,
          width: 600,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomAd(width: size.width.floor()),
                Container(
                    padding: const EdgeInsets.all(10.0),
                    // child: Image.network(currentUser.image!, fit: BoxFit.cover),
                    child: userImage(currentUser)),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  "Nombre del usuario",
                  textAlign: TextAlign.center,
                ),
                CustomTextForm(
                  hintText: currentUser.username,
                  initialValue: currentUser.username,
                  enabled: false,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  "Nombre",
                  textAlign: TextAlign.center,
                ),
                CustomTextForm(
                  hintText: currentUser.name,
                  initialValue: currentUser.name,
                  enabled: false,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  "Apellidos",
                  textAlign: TextAlign.center,
                ),
                CustomTextForm(
                  hintText: currentUser.surname,
                  initialValue: currentUser.surname,
                  enabled: false,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  "Ciudad",
                  textAlign: TextAlign.center,
                ),
                CustomTextForm(
                  hintText: currentUser.city,
                  initialValue: currentUser.city,
                  enabled: false,
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                  height: 20,
                  indent: 20,
                  endIndent: 20,
                ),
                Text(
                  "Email",
                  textAlign: TextAlign.center,
                ),
                CustomTextForm(
                  hintText: currentUser.email,
                  initialValue: currentUser.email,
                  enabled: false,
                ),
                GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'preferences'),
                    child: const CustomButton(text: 'Tus preferencias')),
                GestureDetector(
                    onTap: () => Navigator.pushNamed(context, 'editProfile'),
                    child: const CustomButton(text: 'Editar perfil')),
                GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, 'editCredentials'),
                    child: const CustomButton(text: 'Cambiar contraseña')),
                GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, 'settings'),
                    child: const CustomButton(text: 'Ajustes')),
                const DeleteProfile(),
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
    final userService = Provider.of<UsersService>(context);
    final currentUser = userService.currentUser!;

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
                    UsersService().deleteProfile(currentUser,
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