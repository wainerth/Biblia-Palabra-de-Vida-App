import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/routes/router_page.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';

import 'package:biblia_palabra_de_vida_app/widgets/loading_service.dart';
import 'package:biblia_palabra_de_vida_app/widgets/text_with_gradient.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Bloquear orientación a portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await PreferencesManager().init();

  final socketProvider = SocketClientProvider();
  await socketProvider.initializeNotificationSystem();
  if (!kIsWeb) {
    await FlutterDownloader.initialize(
      debug: kDebugMode,
      ignoreSsl: kDebugMode,
    );
  }

  debugPrint = (String? message, {int? wrapWidth}) {
    // Logs detallados solo en modo debug
    if (message != null && message.contains('GraphQL')) {
      print('🎯 [GRAPHQL_DEBUG] $message');
    }
  };
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
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Esperar a que Flutter esté listo
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final context = navigatorKey.currentContext;
      if (context != null) {
        final catalogueProvider =
            Provider.of<CatalogueProvider>(context, listen: false);
        await catalogueProvider.initialize();
      }
    });
  }

  Future<void> _loadDataPreferences() async {
    try {
      // Verificar si ya vio el intro
      final hasSeen = await PreferencesManager().hasSeenIntro();

      setState(() => _hasSeenIntro = hasSeen);
    } catch (e) {
      if (e.toString().contains('StreamCorruptedException')) {
        try {
          // 1. Limpia en memoria
          await PreferencesManager().clearAll();

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
    }
  }

// function to load the token and initialize the authentication
  Future<void> _loadTokenAndInitializeAuth() async {
    final authProvider = context.read<AuthenticationProvider>();
    try {
      await authProvider.checkAuthentication(context);
    } catch (e) {
      debugPrint('⚠️ Error en _loadTokenAndInitializeAuth: $e');
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
    if (_hasSeenIntro == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_hasSeenIntro!) {
      final authProvider = context.read<AuthenticationProvider>();
      return FutureBuilder(
        future: _loadTokenAndInitializeAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadMaskedWidget();
          } else {
            LoadingService().hideLoading();

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
