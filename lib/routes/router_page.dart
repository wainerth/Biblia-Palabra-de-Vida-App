import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';

final Map<String, WidgetBuilder> routes = {
  '/introPage': (BuildContext context) => const WelcomeScreen(),
  '/homePage': (BuildContext context) => const HomeScreen(),
  '/loginPage': (BuildContext context) => const LoginScreen(),
  '/registerPage': (BuildContext context) => const RegisterScreen(),
  '/forgotPasswordPage': (BuildContext context) => const RecoverPassScreen(),
  '/changePasswordPage': (BuildContext context) => const ChangePassScreen(),
  '/layoutPage': (BuildContext context) => const PageScreen(),
  '/layoutPage1': (BuildContext context) => const LayoutScreen(),
  '/mapPage': (BuildContext context) => const MapScreen(),
  '/introAventurePage': (BuildContext context) => IntroAventureScreen(),
  '/aventurePage': (BuildContext context) => AventureScreen(),
  '/bibliaPage': (BuildContext context) => BibleScreen(),
  '/communityPage': (BuildContext context) => GraphQLConfig.development ? CommunityScreen() : SoonScreen(), 
  '/profilePage': (BuildContext context) => ProfileScreen(),
  '/workspacePage': (BuildContext context) =>
      AuthGuard(child: WorkspaceScreen()),
  '/detailsProgressPage': (BuildContext context) => ProgressDetailScreen(),
  '/prayerPage': (BuildContext context) => PrayerScreen(),
  '/listRequestPage': (BuildContext context) => ListRequestScreen(),
  '/detailPrayerPage': (BuildContext context) => DetailRequestScreen(),
  '/detailCoursePage': (BuildContext context) => DetailCourseScreen(),
  '/historyPage': (BuildContext context) => HistoryScreen(),
  '/questionPage': (BuildContext context) => QuestionScreen(),
  '/soonPage': (BuildContext context) => SoonScreen(),
  '/preachPage': (BuildContext context) => PreachScreen(),
  '/promisePage': (BuildContext context) => PromisesScreen(), //SoonScreen(),
  '/playPage': (BuildContext context) => GraphQLConfig.development ? PlayScreen() : SoonScreen(), 
  '/settingPage': (BuildContext context) => AuthGuard(child: SettingsScreen()),
  '/leaguePage': (BuildContext context) => RankingScreen(),
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
