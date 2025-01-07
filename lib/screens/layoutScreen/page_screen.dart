import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/utils/bottom_navigation_items.dart';
import 'package:flutter/material.dart';

class PageScreen extends StatefulWidget {
  const PageScreen({super.key});

  @override
  State<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    ProfileScreen(),
    AudioScreen(),
    FavoriteScreen(),
    ConfigScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: Color(0XFF7D7878),
        selectedItemColor: Color(0XFF12CBC4),
        unselectedItemColor: Colors.white,
        items: getBottomNavigationBarItems(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
