import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/services/navigation_service.dart';
import 'package:biblia_palabra_de_vida_app/services/remote_config_service.dart';
import 'package:biblia_palabra_de_vida_app/utils/route_observer.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:biblia_palabra_de_vida_app/services/audio_service.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp();

  // Remote Config
  final remoteConfigService = RemoteConfigService();
  await remoteConfigService.initialize(
    onConfigUpdated: () {
      NavigationService().handleRemoteConfigUpdate(remoteConfigService);
    },
  );

  // Configuraciones del sistema
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  //Providers
  final translationProvider = AppTranslationProvider();
  await translationProvider.initialize();
  await PreferencesManager().init();
  final audioService = AudioService();

  // Notificaciones
  final socketProvider = SocketClientProvider();
  await socketProvider.initializeNotificationSystem();

  if (!kIsWeb) {
    await FlutterDownloader.initialize(
      debug: kDebugMode,
      ignoreSsl: kDebugMode,
    );
  }

  // debug
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null && message.contains('GraphQL')) {
      if (kDebugMode) {
        print('🎯 [GRAPHQL_DEBUG] $message');
      }
    }
  };

  // Run App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => translationProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => socketProvider),
        ChangeNotifierProvider(create: (_) => ExchangeRateProvider()),
        ChangeNotifierProvider<CatalogueProvider>(
            create: (_) => CatalogueProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (context) => AuthenticationProvider(context)),
        ChangeNotifierProvider(create: (_) => BibleThemeProvider()),
        Provider<RemoteConfigService>(create: (_) => remoteConfigService),
      ],
      child: ScreenUtilInit(
        designSize: getDesignSize(),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MyApp(audioService: audioService);
        },
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final AudioService audioService;

  const MyApp({super.key, required this.audioService});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    _loadDataPreferences();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationService().applyOrientationPolicy();
    });
  }

  Future<void> _loadDataPreferences() async {
    try {
      final hasSeen = await PreferencesManager().hasSeenIntro();
      NavigationService().updateHasSeenIntro(hasSeen);
    } catch (e) {
      if (e.toString().contains('StreamCorruptedException')) {
        try {
          await PreferencesManager().clearAll();
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
  void dispose() {
    RemoteConfigService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return MaterialApp(
      title: 'Palabra de Vida',
      navigatorKey: navigatorKey,
       navigatorObservers: [routeObserver],
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
      home: SplashScreen(
        onComplete: () {
          NavigationService().goToInitialScreen();
        },
      ),
      routes: routes,
      onGenerateRoute: generateRoute,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
              text: "La Biblia",
              font: StylesApp(context).textStyleBody1,
            )
          ],
        ),
      ),
    );
  }
}
