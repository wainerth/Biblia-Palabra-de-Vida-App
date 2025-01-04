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
    Configscreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        // Personaliza los estilos si es necesario
        backgroundColor: Color(0xFF7D7878), // Fondo blanco para mayor visibilidad
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: getBottomNavigationBarItems(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
