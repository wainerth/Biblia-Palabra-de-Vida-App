import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:flutter/material.dart';


class DynamicBottomNavigationBar extends StatelessWidget {
  final List<BottomNavItem> items;
  final int selectedIndex;
  final Function(int) onTap;

  const DynamicBottomNavigationBar({
    Key? key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items.map((item) {
        return BottomNavigationBarItem(
          icon: Icon(item.icon),
          label: item.title,
        );
      }).toList(),
      currentIndex: selectedIndex,
      onTap: onTap,
    );
  }
}
