import 'package:biblia_palabra_de_vida_app/models/bottom_nav_item.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter/material.dart';


List<BottomNavigationBarItem> getBottomNavigationBarItems(BuildContext context) {
  return [
     BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined,size: StylesApp(context).sizeIconBottomBar,),
      label: 'Inicio',
    ),
     BottomNavigationBarItem(
      icon: Icon(Icons.book_outlined,size: StylesApp(context).sizeIconBottomBar,),
      label: 'Biblia',
    ),
     BottomNavigationBarItem(
      icon: Icon(Icons.church,size: StylesApp(context).sizeIconBottomBar,),
      label: 'Oración',
    ),
     BottomNavigationBarItem(
      icon: Icon(Icons.audiotrack,size: StylesApp(context).sizeIconBottomBar,),
      label: 'Música',
    ),
     BottomNavigationBarItem(
      icon: Icon(Icons.favorite,size: StylesApp(context).sizeIconBottomBar,),
      label: 'Ofrendas',
    ),
     BottomNavigationBarItem(
      icon: Icon(Icons.settings,size: StylesApp(context).sizeIconBottomBar,),
      label: 'Configuración',
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
        title: "Ranking", icon: Icons.area_chart_sharp, page: RankingScreen()),
    BottomNavItem(title: "Dudas", icon: Icons.question_mark_outlined, page: DoubtScreen()),
    BottomNavItem(
        title: "Reto online",
        icon: Icons.language,
        page: OnlineChallengeScreen()),
    BottomNavItem(
        title: "Novedad",
        icon: Icons.notifications_none_rounded,
        page: NewsScreen())
  ];
  
final List<BottomNavItem> itemsMap = [
    BottomNavItem(
        title: "Inicio",
        icon: Icons.home_outlined,
        page: WorkspaceScreen()),
    BottomNavItem(
        title: "Aventuras",
        icon: Icons.directions_walk_outlined,
        page: AventureScreen()),
    BottomNavItem(
        title: "Mapa", icon: Icons.map_rounded, page: MapScreen()),
    BottomNavItem(title: "Dudas", icon: Icons.question_mark_outlined, page: DoubtScreen()),
    BottomNavItem(
        title: "Reto online",
        icon: Icons.language,
        page: OnlineChallengeScreen()),
    BottomNavItem(
        title: "Novedad",
        icon: Icons.notifications_none_rounded,
        page: NewsScreen())
  ];