import 'package:flutter/material.dart';

class NavbarProvider with ChangeNotifier {
  int _selectedPageIndex = 0;
  int get selectedPageIndex => _selectedPageIndex;

  set selectedPageIndex(int index) {
    _selectedPageIndex = index;
    notifyListeners();
  }
}
