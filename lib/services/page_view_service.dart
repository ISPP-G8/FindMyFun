import 'package:flutter/material.dart';

class PageViewService extends ChangeNotifier{
  PageController _loginPageController = PageController();
  PageController _registerPageController = PageController();
  

  PageController get pageController => _loginPageController;

  void set pageController(PageController controller){
    _loginPageController = controller;
    notifyListeners();
  }
  PageController get registerPageController => _registerPageController;

  void set registerPageController(PageController controller){
    _registerPageController = controller;
    notifyListeners();
  }
}