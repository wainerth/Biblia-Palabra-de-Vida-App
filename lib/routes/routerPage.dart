import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/introPage': (BuildContext context) => const WelcomeScreen(),
  '/homePage': (BuildContext context) => const Homescreen(),
  '/loginPage':( BuildContext context) => const LoginScreen(),
  
};
