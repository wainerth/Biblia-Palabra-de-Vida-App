import 'package:biblia_palabra_de_vida_app/routes/routerPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/theme_provider.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: ScreenUtilInit(
        designSize: Size(360, 690), // Tamaño base del diseño
        builder: (context, child) {
          return MyApp();
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
  bool? _hasSeenIntro; // Usar null para diferenciar cuando aún no está cargado.

  @override
  void initState() {
    super.initState();
    _loadDataPreferences();
  }

  Future<void> _loadDataPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      print("esperando asignación");
      _hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Cuando _hasSeenIntro no es null, renderizar la ruta inicial.
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeProvider.currentTheme,
      // initialRoute:_hasSeenIntro! ? '/loginPage' : '/loginPage', // Asegurarse de que no sea null.
      home: _buildHomeScreen() ,
      routes: routes,
    );
  }

  Widget _buildHomeScreen() {
    // Mostrar indicador de carga mientras _hasSeenIntro es null.
    if (_hasSeenIntro == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Decidir la pantalla inicial con base en el valor de _hasSeenIntro.
    return _hasSeenIntro! ? const LoginScreen() : const WelcomeScreen();
  }
}
