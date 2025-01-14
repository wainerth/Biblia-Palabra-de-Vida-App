import 'package:flutter/material.dart';

class CustomBottomNavigationBarWidget extends StatelessWidget {
  final BottomNavigationBarType type;
  final bool showUnselectedLabels;
  final Color backgroundColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;
  final List<BottomNavigationBarItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBarWidget({
    super.key,
    required this.type,
    required this.showUnselectedLabels,
    required this.backgroundColor,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    required this.selectedLabelStyle,
    required this.unselectedLabelStyle,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: type,
      showUnselectedLabels: showUnselectedLabels,
      backgroundColor: backgroundColor,
      selectedItemColor: selectedItemColor,
      unselectedItemColor: unselectedItemColor,
      selectedLabelStyle: selectedLabelStyle,
      unselectedLabelStyle: unselectedLabelStyle,
      items: items,
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
