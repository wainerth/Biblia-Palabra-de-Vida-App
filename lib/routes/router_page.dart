import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/introPage': (BuildContext context) => const WelcomeScreen(),
  '/homePage': (BuildContext context) => const HomeScreen(),
  '/loginPage': (BuildContext context) => const LoginScreen(),
  '/registerPage': (BuildContext context) => const RegisterScreen(),
  '/forgotPasswordPage': (BuildContext context) => const RecoverPassScreen(),
  '/changePasswordPage': (BuildContext context) => const ChangePassScreen(),
  '/layoutPage': (BuildContext context) => const PageScreen(),
  '/layoutPage1': (BuildContext context) => const LayoutScreen(),
  '/mapPage': (BuildContext context) =>const MapScreen(),
  '/introAventurePage': (BuildContext context) => IntroAventureScreen(),
  '/aventurePage': (BuildContext context) => AventureScreen(),
  '/bibliaPage': (BuildContext context) => BibleScreen(),
  '/communityPage': (BuildContext context) => CommunityScreen(),
  '/profilePage': (BuildContext context) => ProfileScreen(),
  '/workspacePage':(BuildContext context)=> WorkspaceScreen() ,
  '/detailsProgressPage': (BuildContext context) => ProgressDetailScreen(),
};

Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name == '/requestPage') {
    final Map<String, dynamic> args =
        settings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
      builder: (context) => RequestPrayerScreen(args: args),
    );
  }

  // Handle other routes here

  return MaterialPageRoute(
    builder: (context) => UnknownScreen(), // A fallback page for unknown routes
  );
}
