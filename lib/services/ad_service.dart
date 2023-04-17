import 'dart:io';
import 'package:flutter/material.dart';

class AdService extends ChangeNotifier {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8269759683506975/3164202818'; //Id de producción
      //return 'ca-app-pub-3940256099942544/6300978111'; // Id de testeo
    }
    return null;
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8269759683506975/2001781497'; //Id de producción
      //return 'ca-app-pub-3940256099942544/1033173712'; // Id de testeo
    }
    return null;
  }
}
