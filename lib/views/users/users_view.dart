import 'dart:ui';

import 'package:findmyfun/services/page_view_service.dart';
import 'package:findmyfun/themes/themes.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsersListViewScreen extends StatelessWidget {
  const UsersListViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageViewController =
        Provider.of<PageViewService>(context).pageController;
    return SafeArea(
      child: Scaffold(
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
            title: Text('USUARIOS',
                textAlign: TextAlign.center, style: Styles.appBar),
          ),
          backgroundColor: ProjectColors.primary,
          body: Column(children: const [
            SizedBox(
              height: 20,
            ),
            UsersContainer(
              child: _UsersColumn(),
            )
          ])),
    );
  }
}

class _UsersColumn extends StatelessWidget {
  const _UsersColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        SizedBox(
            height: 500,
            width: 325,
            child: ListView.separated(
              itemCount: 30,
              itemBuilder: (context, index) {
                return const ListTile(
                  title: Text('Name Surname'),
                  subtitle: Text('username \nmail@mail.com'),
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            )),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
