import 'package:auto_size_text/auto_size_text.dart';
import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/themes/colors.dart';
import 'package:findmyfun/themes/styles.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventCreatorProfileDetailsView extends StatelessWidget {
  const EventCreatorProfileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final eventCreator = ModalRoute.of(context)!.settings.arguments as User;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.chevron_left_outlined,
            size: 44,
            color: ProjectColors.secondary,
          ),
        ),
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
                Container(
                    padding: const EdgeInsets.all(10.0),
                    // child: Image.network(currentUser.image!, fit: BoxFit.cover),
                    child: userImage(eventCreator)),
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
                  hintText: eventCreator.username,
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
                  hintText: eventCreator.name,
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
                  hintText: eventCreator.surname,
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
                  hintText: eventCreator.city,
                  enabled: false,
                ),
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
