import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  bool isDark = true;

  void toggle() {
    isDark = !isDark;
    notifyListeners();
  }
}
