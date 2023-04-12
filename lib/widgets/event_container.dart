import 'package:flutter/material.dart';

import '../models/models.dart';
import '../themes/themes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: ProjectColors.primary,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(event.startDate.toString(),
                        style: GoogleFonts.kanit(fontSize: 18)),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(event.address),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('${event.users.length} asistente/s'),
                  ],
                )),
                const Spacer(),
                Flexible(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(minHeight: 200, minWidth: 150),
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
              ],
            ),
            const Divider(
              color: Colors.grey,
              thickness: 0.5,
              height: 20,
              indent: 20,
              endIndent: 20,
            ),
          ],
        ),
      ),
    );
  }
}
