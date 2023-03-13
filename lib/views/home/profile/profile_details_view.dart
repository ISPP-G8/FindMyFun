import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/auth_service.dart';
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
      // floatingActionButton: FloatingActionButton(onPressed: () {}),
      backgroundColor: ProjectColors.primary,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.chevron_left,
              size: 45,
            )),
        backgroundColor: ProjectColors.primary,
        elevation: 0,
        centerTitle: true,
        title: Text('MI PERFIL',
            textAlign: TextAlign.center, style: Styles.appBar),
      ),
      body: Center(
        child: Container(
          height: 800,
          width: 400,
          decoration: BoxDecoration(
            color: const Color(0xff828a92),
            borderRadius: BorderRadius.circular(15),
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
                  enabled: false,
                ),
                CustomTextForm(
                  hintText: currentUser.name,
                  enabled: false,
                ),
                CustomTextForm(
                  hintText: currentUser.surname,
                  enabled: false,
                ),
                CustomTextForm(
                  hintText: currentUser.city,
                  enabled: false,
                ),
                CustomTextForm(
                  hintText: currentUser.email,
                  enabled: false,
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'preferences'),
                  child: const CustomButton(text: 'Tus preferencias')),
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
        backgroundImage: AssetImage('assets/placeholder.png'),
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
