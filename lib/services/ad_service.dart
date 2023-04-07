import 'dart:io';
import 'package:flutter/material.dart';

class AdService extends ChangeNotifier {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      //return 'ca-app-pub-8269759683506975/4500501066'; Id de producción
      return 'ca-app-pub-3940256099942544/6300978111'; // Id de testeo
    }
    return null;
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8269759683506975/4500501066';
    }
    return null;
  }
}
