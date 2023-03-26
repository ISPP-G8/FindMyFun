import 'package:flutter/material.dart';

import '../models/models.dart';
import '../themes/themes.dart';
import 'widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventContainer extends StatelessWidget {
  final Event event;
  const EventContainer({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
          color: ProjectColors.secondary,
          boxShadow: [
            BoxShadow(color: Colors.black54, spreadRadius: 1, blurRadius: 7)
          ]
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    event.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(event.startDate.toString()),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(event.address),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('${event.users.length} asistente/s'),
                ],
              ),
              const Spacer(),
              Container(
                  width: 150,
                  height: size.height*0.12,
                  child: CachedNetworkImage(
                    imageUrl: event.image,
                    errorWidget: (context, url, error) {
                      // ignore: avoid_print
                      print('Error al cargar la imagen $error');
                      return Image.asset('assets/placeholder.png');
                    },
                    progressIndicatorBuilder: (context, url, progress) =>
                        CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  ))
            ],
          ),
          CustomButton(
            text: 'Detalles',
            onTap: () =>
                Navigator.pushNamed(context, 'eventDetails', arguments: event),
          ),
        ],
      ),
    );
  }
}
