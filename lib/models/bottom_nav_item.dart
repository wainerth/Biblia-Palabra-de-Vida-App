import 'package:flutter/material.dart';

class BottomNavItem {
  final String title;
  final IconData icon;
  final Widget page;

  BottomNavItem({
    required this.title,
    required this.icon,
    required this.page,
  });
}
