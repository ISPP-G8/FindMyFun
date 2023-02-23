import 'package:flutter/material.dart';

class PageViewService extends ChangeNotifier{
  PageController _loginPageController = PageController();
  

  PageController get pageController => _loginPageController;

  void set(PageController controller){
    _loginPageController = controller;
    notifyListeners();
  }
}