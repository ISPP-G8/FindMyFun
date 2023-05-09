import 'dart:async';
import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/services.dart';
import 'package:findmyfun/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AdPlanLoader extends StatefulWidget {
  const AdPlanLoader({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdPlanLoaderState();
}

class _AdPlanLoaderState extends State<AdPlanLoader> {
  late Future<User> loggedUserFuture;

  Future<User> getLoggedUser() async {
    User user = await UsersService().getCurrentUserWithUid();
    return user;
  }

  @override
  void initState() {
    super.initState();

    loggedUserFuture = getLoggedUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: loggedUserFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.subscription.type == SubscriptionType.free) {
            return const CustomAd();
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
