import 'package:biblia_palabra_de_vida_app/models/bottom_nav_item.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:flutter/material.dart';


List<BottomNavigationBarItem> getBottomNavigationBarItems() {
  return [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined,size: 40.0,),
      label: 'Inicio',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.church,size: 40.0,),
      label: 'Oración',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.audiotrack,size: 40.0,),
      label: 'Música',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.favorite,size: 40.0,),
      label: 'Ofrendas',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.headphones,size: 40.0,),
      label: 'Contacto',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings,size: 40.0,),
      label: 'Settings',
    ),
  ];
}

final List<BottomNavItem> items = [
    BottomNavItem(
        title: "Inicio",
        icon: Icons.home_outlined,
        page: WorkspaceScreen()),
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