import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageControllerService = Provider.of<PageViewService>(context);

    return Scaffold(
        backgroundColor: ProjectColors.primary,
        bottomNavigationBar: const CustomNavigationBar(),
        appBar: AppBar(
          backgroundColor: ProjectColors.primary,
          elevation: 0,
          leading: Image.asset('assets/logo.jpeg'),
          centerTitle: true,
          title: Container(
              height: 50, child: Image.asset('assets/logo-banner.jpeg')),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.chat_bubble,
                size: 50,
              ),
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          child: PageView(
              controller: pageControllerService.mainPageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const []),
        ));
  }
}
