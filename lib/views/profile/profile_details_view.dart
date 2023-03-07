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

    final pageViewController =
        Provider.of<PageViewService>(context).pageController;
    return Scaffold(
      backgroundColor: ProjectColors.primary,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => pageViewController.animateToPage(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut),
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
          //margin: const EdgeInsets.symmetric(horizontal: 30),
          height: 1000,
          width: 400,
          decoration: BoxDecoration(
            color: const Color(0xff828a92),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle, // icono de foto de perfil
                size: 200,
                color: Color.fromARGB(255, 67, 32, 32),
              ),
              SizedBox(height: 20),
              for (var i = 0; i < 6; i++)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                  child: TextField(
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
                text: 'Preferencias',
                onTap: () => pageViewController.animateToPage(3,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut)
              ),
              const SizedBox(height: 5),
              const SubmitButton(text: 'CONTINUAR')
            ],
          ),
        ),
      ),
    );
  }
}
