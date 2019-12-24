import 'package:flutter/material.dart';

class BottomNavigationIcon {
  final BottomNavigationBarItem item;
  final IconData icon;
  final String title;

  BottomNavigationIcon(this.title, this.icon)
      : item = BottomNavigationBarItem(title: Text(title), icon: Icon(icon));
}
