import 'package:findmyfun/themes/colors.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';
import '../views/views.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
            final pageViewService = Provider.of<PageViewService>(context);

    return  SafeArea(
      
      child: Scaffold(
        // appBar: AppBar(),
          backgroundColor: ProjectColors.primary,
          body: PageView(
            controller: pageViewService.registerPageController,
            children: const [
              RegisterViewForm(),
              RegisterViewPlan()
            ],
          )),
    );
  }
}

