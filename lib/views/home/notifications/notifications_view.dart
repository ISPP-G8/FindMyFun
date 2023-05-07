import 'package:auto_size_text/auto_size_text.dart';
import 'package:findmyfun/services/auth_service.dart';
import 'package:findmyfun/services/important_notification_service.dart';
import 'package:findmyfun/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/models.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    Provider.of<ImportantNotificationService>(context, listen: false)
        .getNotifications(AuthService().currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notificationsService =
        Provider.of<ImportantNotificationService>(context);
    return Scaffold(
        appBar: AppBar(
          title: const AutoSizeText(
            'NOTIFICACIONES',
            maxLines: 1,
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
              if (notificationsService.notifications.isNotEmpty)
                ...notificationsService.notifications
                    .map((e) => NotificatoinContainer(
                          notification: e!,
                        )),
              if (notificationsService.notifications.isEmpty)
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(20),
                  child: const AutoSizeText(
                    'No tienes notificaciones',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                )
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
