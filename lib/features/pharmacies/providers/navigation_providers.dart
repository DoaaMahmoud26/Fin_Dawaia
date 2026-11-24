import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _index = 0;
  int get index => _index;
  void goTo(int value) {
    if (value < 0 || value > 5 || value == _index) return;
    _index = value;
    notifyListeners();
  }
}