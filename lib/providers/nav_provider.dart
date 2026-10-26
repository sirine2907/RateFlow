import 'package:flutter/material.dart';

// Tracks which bottom-nav tab is selected, so other screens (like
// Favorites) can jump back to the Convert tab after picking a pair.
class NavProvider extends ChangeNotifier {
  int index = 0;

  void goTo(int newIndex) {
    index = newIndex;
    notifyListeners();
  }
}
