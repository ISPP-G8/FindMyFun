import 'package:flutter/material.dart';

class PageViewService extends ChangeNotifier {
  PageController _loginPageController = PageController();
  PageController _registerPageController = PageController();

  int _navigationBarPage = 0;

  int get navigationBarPage => _navigationBarPage;

  set navigationBarPage(int val) {
    _navigationBarPage = val;
    notifyListeners();
  }

  PageController get pageController => _loginPageController;

  void set pageController(PageController controller) {
    _loginPageController = controller;
    notifyListeners();
  }

  PageController get registerPageController => _registerPageController;

  void set registerPageController(PageController controller) {
    _registerPageController = controller;
    notifyListeners();
  }
}
