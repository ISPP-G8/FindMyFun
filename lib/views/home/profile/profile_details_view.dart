import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/users_service.dart';
import 'package:findmyfun/themes/colors.dart';
import 'package:findmyfun/themes/styles.dart';
import 'package:findmyfun/widgets/custom_text_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileDetailsView extends StatelessWidget {
  const ProfileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileViewService = Provider.of<UsersService>(context);

    User userSelected;
    profileViewService
        .getUserWithUid('OjLDdgjOedeILmbwik90hW7YUlq1')
        .then((value) {
      print(value);
    });

    // User userSelected;
    // Future<User> _userSelected(String userId) async {
    //   User userSelected;
    //   var snapshot =
    //       await profileViewService.getUserWithUid(userId).then((value) {
    //     userSelected = value;
    //     return userSelected;
    //   });
    // }

    // void userSelectedFunc() async {
    //   final userSelected = await _userSelected('OjLDdgjOedeILmbwik90hW7YUlq1');
    // }

    // User userSelected = User(
    //     id: "1",
    //     image:
    //         "https://www.google.com/url?sa=i&url=https%3A%2F%2Fes.dreamstime.com%2Ffoto-de-archivo-persona-feliz-en-el-campo-image42388021&psig=AOvVaw1MSO-DFzC-u5H17VRNg93G&ust=1678554113861000&source=images&cd=vfe&ved=0CA8QjRxqFwoTCNDS8r7r0f0CFQAAAAAdAAAAABAQ",
    //     name: "a",
    //     surname: "a",
    //     username: "a",
    //     city: "a",
    //     email: "a",
    //     preferences: []);
    // profileViewService
    //     .getUserWithUid('OjLDdgjOedeILmbwik90hW7YUlq1')
    //     .then((value) {
    //   userSelected = value;
    // });

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {}),
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
                  //child: Image.network(userSelected.image, fit: BoxFit.cover),
                ),
                // CustomTextForm(
                //   hintText: userSelected.username,
                //   enabled: false,
                // ),
                // CustomTextForm(
                //   hintText: userSelected.name,
                //   enabled: false,
                // ),
                // CustomTextForm(
                //   hintText: userSelected.surname,
                //   enabled: false,
                // ),
                // CustomTextForm(
                //   hintText: userSelected.city,
                //   enabled: false,
                // ),
                // CustomTextForm(
                //   hintText: userSelected.email,
                //   enabled: false,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
