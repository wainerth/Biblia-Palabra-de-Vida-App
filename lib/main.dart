import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/routes/router_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690), // Tamaño base del diseño
        builder: (context, child) {
          WidgetsFlutterBinding.ensureInitialized();

          return const MyApp();
        },
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _hasSeenIntro;

  @override
  void initState() {
    super.initState();
    _loadDataPreferences();
  }

  Future<void> _loadDataPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // print("esperando asignación");
      _hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español (España)
      ],
      home: _buildHomeScreen(),
      routes: routes,
    );
  }

  Widget _buildHomeScreen() {
    // Mostrar indicador de carga mientras _hasSeenIntro es null.
    if (_hasSeenIntro == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Decidir la pantalla inicial con base en el valor de _hasSeenIntro.
    return _hasSeenIntro! ? const HomeScreen() : const WelcomeScreen();
  }
}
