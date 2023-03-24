import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/users_service.dart';
import 'package:findmyfun/themes/colors.dart';
import 'package:findmyfun/themes/styles.dart';
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
          'MI PERFIL',
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: const EdgeInsets.all(10.0),
                    // child: Image.network(currentUser.image!, fit: BoxFit.cover),
                    child: userImage(currentUser)),
                CustomTextForm(
                  hintText: currentUser.username,
                  initialValue: currentUser.username,
                  enabled: false,
                ),
                CustomTextForm(
                  hintText: currentUser.name,
                  initialValue: currentUser.name,
                  enabled: false,
                ),
                CustomTextForm(
                  hintText: currentUser.surname,
                  initialValue: currentUser.surname,
                  enabled: false,
                ),
                CustomTextForm(
                  hintText: currentUser.city,
                  initialValue: currentUser.city,
                  enabled: false,
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
                    child: const CustomButton(text: 'Editar Perfil')),
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
