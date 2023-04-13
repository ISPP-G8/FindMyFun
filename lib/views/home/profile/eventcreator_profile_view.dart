import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/themes/styles.dart';
import 'package:findmyfun/widgets/custom_banner_ad.dart';
import 'package:findmyfun/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/services/services.dart';

class EventCreatorProfileDetailsView extends StatelessWidget {
  const EventCreatorProfileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UsersService>(context);
    final event = ModalRoute.of(context)!.settings.arguments as Event;
    final size = MediaQuery.of(context).size;

    Future<User> getEventCreator() async {
      User eventCreator = await userService.getUserWithUid(event.users.first);
      return eventCreator;
    }

    User eventCreator = getEventCreator();
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
