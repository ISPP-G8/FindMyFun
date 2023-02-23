import 'package:findmyfun/themes/colors.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../views/views.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      
      child: Scaffold(

          backgroundColor: ProjectColors.primary,
          body: PageView(
            children: const [
              RegisterViewForm(),
            ],
          )),
    );
  }
}

