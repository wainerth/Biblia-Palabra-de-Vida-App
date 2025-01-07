
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/introPage': (BuildContext context) => const WelcomeScreen(),
  '/homePage': (BuildContext context) => const HomeScreen(),
  '/loginPage':( BuildContext context) => const LoginScreen(),
  '/registerPage':( BuildContext context) => const RegisterScreen(),
  '/forgotPasswordPage':( BuildContext context) => const RecoverPassScreen(),
  '/changePasswordPage':( BuildContext context) => const ChangePassScreen(),
  '/layoutPage': (BuildContext context) => const PageScreen(),
  '/layoutPage1': (BuildContext context) => const LayoutScreen(),
  '/mapPage': (BuildContext context) => MapScreen(levels: [],),
  '/introAventurePage' : (BuildContext context) => IntroAventureScreen(),
  '/aventurePage': (BuildContext context) => AventureScreen(),
  '/bibliaPage': (BuildContext context) =>BibleScreen(),
  '/communityPage': (BuildContext context) => CommunityScreen(),
  '/detailProfilePage': (BuildContext context) => DetailProfileScreen(),
  '/detailsProgressPage':(BuildContext context)=> ProgressDetailScreen()
};
