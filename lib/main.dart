import 'dart:io';

import 'package:biblia_palabra_de_vida_app/class/error_reporter.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/routes/router_page.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/loading_service.dart';
import 'package:biblia_palabra_de_vida_app/widgets/text_with_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final socketProvider = SocketClientProvider();
  await socketProvider.initializeNotifications();
  if (!kIsWeb) {
    await FlutterDownloader.initialize(
      debug: true, // Set to false in production
      ignoreSsl: true, // Set to false for secure connections
    );
  }
  // Manejo de errores global
  // FlutterError.onError = (details) {
  //   ErrorReporter.sendError(
  //     nameFunction: "Error Global",
  //     error: details.exception,
  //     stackTrace: details.stack ?? StackTrace.current,
  //   );
  //   // También puedes mostrar un diálogo al usuario
  //   debugPrint('Error: ${details.exception}');
  // };
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => socketProvider),
        ChangeNotifierProvider<CatalogueProvider>(
            create: (_) => CatalogueProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<AuthenticationProvider>(
          create: (context) => AuthenticationProvider(
              context, context.read<CatalogueProvider>()),
        ),
        ChangeNotifierProvider(create: (_) => BibleThemeProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690), // size base of design
        builder: (context, child) {
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
    SharedPreferences? prefs;
    try {
      prefs = await SharedPreferences.getInstance();
      setState(() {
        _hasSeenIntro = prefs!.getBool('hasSeenIntro') ?? false;
      });
    } catch (e) {
      if (e.toString().contains('StreamCorruptedException')) {
        try {
          // 1. Limpia en memoria
          final prefs = await SharedPreferences.getInstance();
          await prefs.clear();

          // 2. Elimina el archivo físico (definitivo)
          final appDir = await getApplicationSupportDirectory();
          final prefsFile =
              File('${appDir.path}/shared_prefs/FlutterSharedPreferences.xml');
          if (await prefsFile.exists()) {
            await prefsFile.delete();
          }

          debugPrint('✅ Datos corruptos eliminados completamente');
        } catch (e) {
          debugPrint('⚠️ Error en limpieza: $e');
        }
      }
      // await ErrorReporter.sendError(
      //     nameFunction: "_loadDataPreferences", error: e, stackTrace: stack);
      // setState(() {
      //   _hasSeenIntro = false; // Valor por defecto si hay error
      // });
    }
  }

// function to load the token and initialize the authentication
  Future<void> _loadTokenAndInitializeAuth() async {
    final authProvider = context.read<AuthenticationProvider>();
    try {
      await authProvider.checkAuthentication(context);
    } catch (e, stack) {
      await ErrorReporter.sendError(
          nameFunction: "_loadTokenAndInitializeAuth",
          error: e,
          stackTrace: stack);
      // authProvider.clearAllSharedPreferences();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Palabra de Vida',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: themeProvider.currentTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Spanish (España)
      ],
      home: SafeArea(
        child: _buildHomeScreen(),
      ),
      routes: routes,
      onGenerateRoute: generateRoute,
    );
  }

  Widget _buildHomeScreen() {
    // if the _hasSeenIntro is null, show a loading spinner
    if (_hasSeenIntro == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_hasSeenIntro!) {
      context.read<AuthenticationProvider>();

      return FutureBuilder(
        future:
            _loadTokenAndInitializeAuth().timeout(const Duration(seconds: 10)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadMaskedWidget();
          } else if (snapshot.hasError) {
            return const HomeScreen(); // Fallback seguro
          } else {
            LoadingService().hideLoading();
            final authProvider = context.read<AuthenticationProvider>();
            if (authProvider.token != null) {
              return PageScreen();
            } else {
              return const HomeScreen();
            }
          }
        },
      );
    } else {
      return const WelcomeScreen();
    }
  }
}

class LoadMaskedWidget extends StatefulWidget {
  const LoadMaskedWidget({
    super.key,
  });

  @override
  State<LoadMaskedWidget> createState() => _LoadMaskedWidgetState();
}

class _LoadMaskedWidgetState extends State<LoadMaskedWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      LoadingService().showLoading(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    LoadingService().hideLoading();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/bibleLogo.png"),
            TextWithGradient(
                text: "La Biblia", font: StylesApp(context).textStyleBody1)
          ],
        ),
      ),
    );
  }
}
