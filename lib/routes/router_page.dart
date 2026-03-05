import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/screens/layoutScreen/layout_library.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

final Map<String, WidgetBuilder> routes = {
  '/loading': (context) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
  '/introPage': (BuildContext context) => const WelcomeScreen(),
  '/homePage': (BuildContext context) => const HomeScreen(),
  '/loginPage': (BuildContext context) => const LoginScreen(),
  '/registerPage': (BuildContext context) => const RegisterScreen(),
  '/forgotPasswordPage': (BuildContext context) => const RecoverPassScreen(),
  '/layoutPage': (BuildContext context) => AuthGuard(child: PageScreen()),
  '/layoutPage1': (BuildContext context) => const LayoutScreen(),
  '/layoutLibrary': (BuildContext context) =>
      GraphQLConfig.development ? const LayoutLibrary() : SoonScreen(),
  '/mapPage': (BuildContext context) => const MapScreen(),
  '/introAventurePage': (BuildContext context) => IntroAventureScreen(),
  '/aventurePage': (BuildContext context) => AventureScreen(),
  '/bibliaPage': (BuildContext context) => BibleScreen(),
  '/searchBiblePage': (BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    return SearchBibleScreen(
      version: args?['version'],
      book: args?['book'],
      chapter: args?['chapter'],
    );
  },
  '/communityPage': (BuildContext context) =>
      GraphQLConfig.development ? CommunityScreen() : SoonScreen(),
  '/profilePage': (BuildContext context) => ProfileScreen(),
  '/workspacePage': (BuildContext context) =>
      AuthGuard(child: WorkspaceScreen()),
  '/detailsProgressPage': (BuildContext context) => ProgressDetailScreen(),
  '/prayerPage': (BuildContext context) => PrayerScreen(),
  '/listRequestPage': (BuildContext context) => ListRequestScreen(),
  '/takePrayerPage': (BuildContext context) => TakePrayerScreen(),
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
  '/aboutScreen': (BuildContext context) => AboutScreen(),
  '/faqScreen': (BuildContext context) => DoubtScreen(),
  '/notificationPage': (BuildContext context) => NotificationScreen(),
  '/offeringPage': (BuildContext context) => OfferingsScreen(),
  '/stripe_payment': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return StripePaymentScreen(
      amount: args['amount'],
      description: args['description'],
      currency: args['currency'],
      donorName: args['donorName'],
      donorEmail: args['donorEmail'],
    );
  },
  '/paypal_payment': (context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    return PayPalPaymentScreen(
      amount: args['amount'],
      description: args['description'],
    );
  },
};

Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name == '/requestPage') {
    final Map<String, dynamic> args =
        settings.arguments as Map<String, dynamic>;
    return MaterialPageRoute(
      builder: (context) => RequestPrayerScreen(args: args),
    );
  }

  return MaterialPageRoute(
    builder: (context) => UnknownScreen(), // A fallback page for unknown routes
  );
}
