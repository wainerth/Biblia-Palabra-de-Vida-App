import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
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
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final translationProvider = AppTranslationProvider();
  await translationProvider.initialize();
  await PreferencesManager().init();

  final socketProvider = SocketClientProvider();
  await socketProvider.initializeNotificationSystem();
  if (!kIsWeb) {
    await FlutterDownloader.initialize(
      debug: kDebugMode,
      ignoreSsl: kDebugMode,
    );
  }
  final catalogueProvider = CatalogueProvider();
  await catalogueProvider.initialize();
  debugPrint = (String? message, {int? wrapWidth}) {
    // Logs detallados solo en modo debug
    if (message != null && message.contains('GraphQL')) {
      if (kDebugMode) {
        print('🎯 [GRAPHQL_DEBUG] $message');
      }
    }
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => translationProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BibleTranslationProvider()),
        ChangeNotifierProvider(create: (_) => socketProvider),
        ChangeNotifierProvider(create: (_) => ExchangeRateProvider()),
        ChangeNotifierProvider<CatalogueProvider>(
            create: (_) => catalogueProvider),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (context) => AuthenticationProvider(context)),
        ChangeNotifierProvider(create: (_) => BibleThemeProvider()),
      ],
      child: ScreenUtilInit(
        designSize: getDesignSize(),
        minTextAdapt: true,
        splitScreenMode: true,
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
  bool _isAuthCheckComplete = false;
  bool _orientationApplied = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Esperar a que Flutter esté listo

    await _loadDataPreferences();
    await _initializeCatalogueProvider();
  }

  Future<void> _initializeCatalogueProvider() async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      final catalogueProvider =
          Provider.of<CatalogueProvider>(context, listen: false);
      try {
        await catalogueProvider.initialize();
      } catch (e) {
        debugPrint('⚠️ Error inicializando catálogo: $e');
        // Permitir que la app continúe incluso si el catálogo falla
      }
    }
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

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (kDebugMode) {
      print('=== TABLET DIAGNOSTIC ===');
      print('Ancho: ${mediaQuery.size.width}');
      print('Alto: ${mediaQuery.size.height}');
      print('Pixel Ratio: ${mediaQuery.devicePixelRatio}');
      print('Orientación: ${mediaQuery.orientation}');
      print('========================');
    }
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
        Locale('es', 'ES'),
      ],
      home: SafeArea(
        child: _buildHomeScreen(),
      ),
      routes: routes,
      onGenerateRoute: generateRoute,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_orientationApplied) {
      _applyOrientationPolicy();
      _orientationApplied = true;
    }
  }

  void _applyOrientationPolicy() {
    try {
      final shortestSide = MediaQuery.of(context).size.shortestSide;
      final bool isTablet = shortestSide >= 550; // standard heuristic

      if (isTablet) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          // DeviceOrientation.portraitDown,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    } catch (e) {
      // If MediaQuery is not available yet or any other error, ignore silently
      debugPrint('Could not apply orientation policy: $e');
    }
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
      return Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
          // si aún no hemos empezado lña verificación, la iniciamos
          if (!_isAuthCheckComplete && !authProvider.isLoading) {
            _startAuthCheck(context);
          }

          // Muestra loading mientras se verifica la autenticación
          if (authProvider.isLoading) {
            return const LoadMaskedWidget();
          }

          // cuando termina la verificación, decidimos qué pantalla mostrar
          if (authProvider.isAuthenticated && authProvider.token != null) {
            return const PageScreen();
          } else {
            return const HomeScreen();
          }
        },
      );
    } else {
      return const WelcomeScreen();
    }
  }

  void _startAuthCheck(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = context.read<AuthenticationProvider>();
      try {
        await authProvider.checkAuthentication(context);
      } catch (e) {
        debugPrint('⚠️ Error en verificación de autenticación: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isAuthCheckComplete = true;
          });
        }
      }
    });
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
