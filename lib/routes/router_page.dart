import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/screens/layoutScreen/layout_library.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  '/introPage': (BuildContext context) => const WelcomeScreen(),
  '/homePage': (BuildContext context) => const HomeScreen(),
  '/loginPage': (BuildContext context) => const LoginScreen(),
  '/registerPage': (BuildContext context) => const RegisterScreen(),
  '/forgotPasswordPage': (BuildContext context) => const RecoverPassScreen(),
  '/changePasswordPage': (BuildContext context) => const ChangePassScreen(),
  '/layoutPage': (BuildContext context) => AuthGuard(child: PageScreen()),
  '/layoutPage1': (BuildContext context) => const LayoutScreen(),
  '/layoutLibrary': (BuildContext context) => const LayoutLibrary(),
  '/mapPage': (BuildContext context) => const MapScreen(),
  '/introAventurePage': (BuildContext context) => IntroAventureScreen(),
  '/aventurePage': (BuildContext context) => AventureScreen(),
  '/bibliaPage': (BuildContext context) => BibleScreen(),
  '/communityPage': (BuildContext context) =>
      GraphQLConfig.development ? CommunityScreen() : SoonScreen(),
  '/profilePage': (BuildContext context) => ProfileScreen(),
  '/workspacePage': (BuildContext context) =>
      AuthGuard(child: WorkspaceScreen()),
  '/detailsProgressPage': (BuildContext context) => ProgressDetailScreen(),
  '/prayerPage': (BuildContext context) =>
      GraphQLConfig.development ? PrayerScreen() : SoonScreen(),
  '/listRequestPage': (BuildContext context) => ListRequestScreen(),
  '/takePrayerPage': (BuildContext context) => TakePrayerScreen(),
  '/detailPrayerPage': (BuildContext context) => DetailRequestScreen(),
  '/detailCoursePage': (BuildContext context) => DetailCourseScreen(),
  '/historyPage': (BuildContext context) => HistoryScreen(),
  '/questionPage': (BuildContext context) => QuestionScreen(),
  '/soonPage': (BuildContext context) => SoonScreen(),
  '/preachPage': (BuildContext context) => PreachScreen(),
  '/promisePage': (BuildContext context) => PromisesScreen(), //SoonScreen(),
  '/playPage': (BuildContext context) => PlayScreen(),
  '/settingPage': (BuildContext context) => AuthGuard(child: SettingsScreen()),
  '/leaguePage': (BuildContext context) => RankingScreen(),
  '/memoryPage': (BuildContext context) => MemoryScreen(),
  '/reddlePage': (BuildContext context) => ReddleScreen(),
  '/quizPage': (BuildContext context) => QuizScreen(),
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
