import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget circleImage(String imagePath) {
  return ClipRRect(
      borderRadius: BorderRadius.circular(250 / 2),
      child: imagePath.isNotEmpty
          ? CachedNetworkImage(
              height: 250,
              width: 250,
              fit: BoxFit.cover,
              imageUrl: imagePath,
              progressIndicatorBuilder: (context, url, progress) =>
                  CircularProgressIndicator(
                      value: progress.downloaded.toDouble()),
            )
          : Image.asset(
              'assets/placeholder.png',
              fit: BoxFit.cover,
              width: 250,
              height: 250,
            ));
}
