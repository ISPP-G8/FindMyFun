import 'package:cached_network_image/cached_network_image.dart';
import 'package:findmyfun/themes/colors.dart';
import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifications = [
      ImportantNotification(
          userId: 'sldkjfh',
          date: DateTime.now(),
          info: 'Juan se ha salido del grupo'),
      ImportantNotification(
          userId: 'fdghgfdhjfd',
          date: DateTime.now(),
          info: 'Manu ha enviado un mensaje'),
      ImportantNotification(
          userId: 'asdfasdf',
          date: DateTime.now(),
          info: 'Pedro se ha unido al grupo'),
      ImportantNotification(
          userId: 'rweter3wt',
          date: DateTime.now(),
          info: 'Luis ha enviado un mensaje'),
      ImportantNotification(
          userId: 'sldkjfh',
          date: DateTime.now(),
          info: 'Juan se ha salido del grupo'),
      ImportantNotification(
          userId: 'fdghgfdhjfd',
          date: DateTime.now(),
          info: 'Manu ha enviado un mensaje'),
      ImportantNotification(
          userId: 'asdfasdf',
          date: DateTime.now(),
          info: 'Pedro se ha unido al grupo'),
      ImportantNotification(
          userId: 'rweter3wt',
          date: DateTime.now(),
          info: 'Luis ha enviado un mensaje'),
      ImportantNotification(
          userId: 'sldkjfh',
          date: DateTime.now(),
          info: 'Juan se ha salido del grupo'),
      ImportantNotification(
          userId: 'fdghgfdhjfd',
          date: DateTime.now(),
          info: 'Manu ha enviado un mensaje'),
      ImportantNotification(
          userId: 'asdfasdf',
          date: DateTime.now(),
          info: 'Pedro se ha unido al grupo'),
      ImportantNotification(
          userId: 'rweter3wt',
          date: DateTime.now(),
          info: 'Luis ha enviado un mensaje'),
      ImportantNotification(
          userId: 'sldkjfh',
          date: DateTime.now(),
          info: 'Juan se ha salido del grupo'),
      ImportantNotification(
          userId: 'fdghgfdhjfd',
          date: DateTime.now(),
          info: 'Manu ha enviado un mensaje'),
      ImportantNotification(
          userId: 'asdfasdf',
          date: DateTime.now(),
          info: 'Pedro se ha unido al grupo'),
      ImportantNotification(
          userId: 'rweter3wt',
          date: DateTime.now(),
          info: 'Luis ha enviado un mensaje'),
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'NOTIFICACIONES',
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: ProjectColors.tertiary,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              ...notifications.map((e) => NotificatoinContainer(
                    notification: e,
                  ))
            ],
          ),
        ));
  }
}

class NotificatoinContainer extends StatelessWidget {
  const NotificatoinContainer({super.key, required this.notification});

  final ImportantNotification notification;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: double.infinity,
        color: ProjectColors.secondary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.info,
              style: const TextStyle(
                  color: ProjectColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(
                '${notification.date.hour}:${notification.date.minute} ${notification.date.day}/${notification.date.month}/${notification.date.year}')
          ],
        ));
  }
}

// ! TODO: Importar esto de los modelos cuando se junte con backend.
class ImportantNotification {
  ImportantNotification(
      {required this.userId, required this.date, required this.info});

  String userId;
  DateTime date;
  String info;
}
