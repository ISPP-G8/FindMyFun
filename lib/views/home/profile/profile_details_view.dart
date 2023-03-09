import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/users_service.dart';
import 'package:findmyfun/themes/colors.dart';
import 'package:findmyfun/themes/styles.dart';
import 'package:findmyfun/widgets/custom_button.dart';
import 'package:findmyfun/widgets/submit_button.dart';
import 'package:flutter/material.dart';
import 'package:findmyfun/services/page_view_service.dart';
import 'package:provider/provider.dart';

class ProfileDetailsView extends StatelessWidget {
  const ProfileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors

    final profileViewService = Provider.of<UsersService>(context);
    var user = profileViewService.getUserDetail('123456');

    final pageViewController =
        Provider.of<PageViewService>(context).pageController;
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
                const Icon(
                  Icons.account_circle, // icono de foto de perfil
                  size: 200,
                  color: Color.fromARGB(255, 67, 32, 32),
                ),
                const SizedBox(height: 20),
                for (var i = 0; i < 6; i++)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                CustomButton(
                    text: user.toString(),
                    onTap: () => pageViewController.animateToPage(1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut)),
                const SizedBox(height: 5),
                const SubmitButton(text: 'CONTINUAR')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
