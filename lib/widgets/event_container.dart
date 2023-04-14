// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../themes/themes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class EventContainer extends StatelessWidget {
  final Event event;
  const EventContainer({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
//    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, 'eventDetails', arguments: event),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          event.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                            DateFormat('yyyy-MM-dd HH:mm')
                                .format(event.startDate),
                            style: GoogleFonts.kanit(fontSize: 12)),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          event.address,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('${event.users.length} asistente/s'),
                      ],
                    )),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        minHeight: 100,
                        maxHeight: 200,
                        minWidth: 100,
                        maxWidth: 200),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87, width: 2)),
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
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
              height: 20,
              indent: 5,
              endIndent: 5,
            ),
          ],
        ),
      ),
    );
  }
}
