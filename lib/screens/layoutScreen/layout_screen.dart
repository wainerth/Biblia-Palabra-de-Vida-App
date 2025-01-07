import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:flutter/material.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 1;

  final List<BottomNavItem> _items = [
    BottomNavItem(
        title: "perfil",
        icon: Icons.account_circle_outlined,
        page: ProfileScreen()),
    BottomNavItem(
        title: "Aventuras",
        icon: Icons.directions_walk_outlined,
        page: AventureScreen()),
    BottomNavItem(
        title: "Ranking", icon: Icons.panorama_rounded, page: RankingScreen()),
    BottomNavItem(title: "Dudas", icon: Icons.menu, page: DoubtScreen()),
    BottomNavItem(
        title: "Reto online",
        icon: Icons.language,
        page: OnlineChallengeScreen()),
    BottomNavItem(
        title: "Novedad",
        icon: Icons.notifications_none_rounded,
        page: NewsScreen())
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushNamed(context, '/layoutPage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _items[_selectedIndex].page,
      bottomNavigationBar: BottomNavigationBar(
         type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
       backgroundColor: Color(0XFF7D7878),
        selectedItemColor: Color(0XFF12CBC4),
        unselectedItemColor: Colors.white,
        items: _items
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.title,
                ))
            .toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
