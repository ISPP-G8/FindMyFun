import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/models/models.dart';
import 'package:findmyfun/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/colors.dart';
import '../../themes/styles.dart';

class EventPointsAdminView extends StatefulWidget {
  const EventPointsAdminView({Key? key}) : super(key: key);

  @override
  State<EventPointsAdminView> createState() => _EventPointsAdminViewState();
}

class _EventPointsAdminViewState extends State<EventPointsAdminView> {
  @override
  void initState() {
    super.initState();

    final usersService = Provider.of<UsersService>(context, listen: false);
    final eventPointsService =
        Provider.of<EventPointsService>(context, listen: false);
    Future.delayed(
      Duration.zero,
      () async =>
          eventPointsService.getEventPointsAdmin(usersService.currentUser!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventPointsService = Provider.of<EventPointsService>(context);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.chevron_left,
                  size: 45,
                  color: ProjectColors.secondary,
                )),
            backgroundColor: ProjectColors.primary,
            elevation: 0,
            centerTitle: true,
            title: FittedBox(
              child: Text('PUNTOS DE EVENTOS',
                  textAlign: TextAlign.center, style: Styles.appBar),
            ),
          ),
          backgroundColor: ProjectColors.primary,
          body: SingleChildScrollView(
            child: Column(children: [
              ...eventPointsService.eventPoints
                  .map((e) => EventPointContainer(eventPoint: e))
            ]),
          )),
    );
  }
}

class EventPointContainer extends StatelessWidget {
  final EventPoint eventPoint;
  const EventPointContainer({super.key, required this.eventPoint});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: ProjectColors.secondary,
          boxShadow: const [BoxShadow(blurRadius: 10, spreadRadius: 0.5)],
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          eventPoint.image.isNotEmpty
              ? SizedBox(
                  height: 100,
                  width: 200,
                  child: CachedNetworkImage(
                    imageUrl: eventPoint.image,
                    errorWidget: (context, url, error) {
                      return Container();
                    },
                  ))
              : Container(),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Id: ${eventPoint.id.substring(0, 5)}...'),
              Text('Nombre: ${eventPoint.name}'),
              Text('Dirección: ${eventPoint.address}, ${eventPoint.city}'),
              Text('Pais: ${eventPoint.country}'),
              Text('LatLng: ${eventPoint.latitude}${eventPoint.longitude}'),
            ],
          )
        ],
      ),
    );
  }
}
