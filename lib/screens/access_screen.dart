import 'package:findmyfun/screens/screens.dart';
import 'package:findmyfun/services/page_view_service.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/views.dart';

class AccessScreen extends StatelessWidget {
   
  const AccessScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final pageControllerService = Provider.of<PageViewService>(context);
    final size = MediaQuery.of(context).size;
    return  Scaffold(
      backgroundColor: ProjectColors.primary,
      body: Container(
        alignment: Alignment.center,
        child:  PageView(
          controller: pageControllerService.pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            AccessView(),
            LoginView(),
            ProfileDetailsView(),
            PreferencesView()
          ]),
      )
    );
  }
}

