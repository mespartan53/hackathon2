import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  int selectedIndex = 0;

  updateIndex(int newIndex) {
    selectedIndex = newIndex;
    notifyListeners();
  }
}