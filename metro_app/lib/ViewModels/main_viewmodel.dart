import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  int selectedIndex = 0;

  updateIndex(int newIndex) {
    selectedIndex = newIndex;
    notifyListeners();
  }
}