import 'package:flutter/material.dart';

List<BottomNavigationBarItem> getBottomNavigationBarItems() {
  return [
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Perfil',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.church),
      label: 'Oración',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.audiotrack),
      label: 'Música',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Ofrendas',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.headphones),
      label: 'Constato',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];
}