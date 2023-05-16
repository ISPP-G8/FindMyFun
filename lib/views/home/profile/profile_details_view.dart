// ignore_for_file: use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/themes/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:intl/intl.dart';

import '../../../themes/colors.dart';

class ProfileDetailsView extends StatefulWidget {
  const ProfileDetailsView({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileDetailsViewState();
}

class _ProfileDetailsViewState extends State<ProfileDetailsView> {
  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UsersService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AutoSizeText(
          'MI PERFIL',
          maxLines: 1,
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
                const AdPlanLoader(),
                FutureBuilder<dynamic>(
                  future: userService.getCurrentUserWithUid(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      User user = snapshot.data!;
                      return Column(
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10.0),
                              // child: Image.network(currentUser.image!, fit: BoxFit.cover),
                              child: circleImage(user.image ?? '')),
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
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w800),
                          ),
                          CustomTextDetail(
                            hintText: user.username,
                            initialValue: user.username,
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
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w800),
                          ),
                          CustomTextDetail(
                            hintText: user.name,
                            initialValue: user.name,
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
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w800),
                          ),
                          CustomTextDetail(
                            hintText: user.surname,
                            initialValue: user.surname,
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
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w800),
                          ),
                          CustomTextDetail(
                            hintText: user.city,
                            initialValue: user.city,
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
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w800),
                          ),
                          CustomTextDetail(
                            hintText: user.email,
                            initialValue: user.email,
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
                            "Suscripción",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w800),
                          ),
                          CustomTextDetail(
                            hintText:
                                getSuscriptionType(user.subscription.type),
                            initialValue:
                                getSuscriptionType(user.subscription.type),
                            enabled: false,
                          ),
                          const Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            height: 20,
                            indent: 20,
                            endIndent: 20,
                          ),
                          Visibility(
                              visible: user.subscription.type !=
                                  SubscriptionType.free,
                              child: Column(
                                children: [
                                  const Text(
                                    "Válido hasta",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  CustomTextDetail(
                                    hintText: '',
                                    initialValue: user
                                                .subscription.validUntil ==
                                            null
                                        ? null
                                        : DateFormat('yyyy-MM-dd HH:mm').format(
                                            user.subscription.validUntil!),
                                    enabled: false,
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 0.5,
                                    height: 20,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                ],
                              )),
                          Visibility(
                            visible: user.subscription.type ==
                                SubscriptionType.company,
                            child: GestureDetector(
                                onTap: () async {
                                  Navigator.pushNamed(
                                      context, 'eventpointcreation');
                                },
                                child: const CustomButton(
                                    text: 'Crear punto de evento')),
                          ),
                          GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, 'preferences'),
                              child:
                                  const CustomButton(text: 'Tus preferencias')),
                          GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, 'editProfile'),
                              child: const CustomButton(text: 'Editar perfil')),
                          GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, 'editCredentials'),
                              child: const CustomButton(
                                  text: 'Cambiar contraseña')),
                          Visibility(
                            visible: user.isAdmin ?? false,
                            child: GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, 'settings'),
                                child: const CustomButton(
                                    text: 'Ajustes de administracion')),
                          ),
                          Visibility(
                            visible:
                                user.subscription.type == SubscriptionType.free,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'registerPlan');
                                },
                                child:
                                    const CustomButton(text: 'Cambiar plan')),
                          ),
                          GestureDetector(
                              onTap: () async {
                                await AuthService().signOut();
                                Navigator.pushReplacementNamed(
                                    context, 'access');
                              },
                              child: const CustomButton(text: 'Cerrar sesión')),
                          const DeleteProfile(),
                        ],
                      );
                    } else {
                      return Column(children: const [
                        SizedBox(height: 100),
                        Center(child: CircularProgressIndicator())
                      ]);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
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
      child: const AutoSizeText(
        'Eliminar cuenta',
        maxLines: 1,
      ),
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
                  onPressed: () async {
                    await userService.deleteProfile(currentUser, context);

                    // Agrega aquí el código que se ejecutará al confirmar
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

String getSuscriptionType(SubscriptionType type) {
  String suscription = "";
  if (type == SubscriptionType.free) {
    suscription = "Gratuita";
  } else if (type == SubscriptionType.premium) {
    suscription = "Premium";
  } else if (type == SubscriptionType.company) {
    suscription = "Empresa";
  }
  return suscription;
}
