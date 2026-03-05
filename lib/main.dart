import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/services/remote_config_service.dart';
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
import 'package:url_launcher/url_launcher.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  final remoteConfigService = RemoteConfigService();
  await remoteConfigService.initialize(
    onConfigUpdated: () {
      // Este callback se ejecutará CADA VEZ que cambien los valores
      print('🔥 [A] CALLBACK EJECUTADO en main.dart');
      print('    Timestamp: ${DateTime.now()}');

      // Verificar valores actuales
      print('    isMaintenanceMode: ${remoteConfigService.isMaintenanceMode}');
      print('    isForceUpdate: ${remoteConfigService.isForceUpdate}');

      _handleRemoteConfigUpdate();
    },
  );
  // remoteConfigService.verifyAllParameters();
  if (kDebugMode) print('✅ Remote Config inicializado');

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  final translationProvider = AppTranslationProvider();
  await translationProvider.initialize();
  await PreferencesManager().init();
  final audioService = AudioService();

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

void _handleRemoteConfigUpdate() async {
 print('🦋 [B] Entrando a _handleRemoteConfigUpdate');
  
  final remoteConfig = RemoteConfigService();
  
  // Verificar valores inmediatamente
  print('   Valores actuales:');
  print('   - maintenance_mode: ${remoteConfig.isMaintenanceMode}');
  print('   - force_update: ${remoteConfig.isForceUpdate}');
  print('   - minimum_version: ${remoteConfig.minimumVersion}');
  
  // Pequeña pausa para asegurar propagación
  await Future.delayed(const Duration(milliseconds: 500));

  WidgetsBinding.instance.addPostFrameCallback((_) {
    print('   [C] PostFrameCallback ejecutado');
    
    final context = navigatorKey.currentContext;
    if (context == null) {
      print('   ❌ Contexto null');
      return;
    }
    
    print('   ✅ Contexto disponible');
    print('   Ruta actual: ${ModalRoute.of(context)?.settings.name}');

    // Verificar modo mantenimiento
    if (remoteConfig.isMaintenanceMode) {
      print('   🚨 MaintenanceMode TRUE - navegando...');
      Navigator.pushReplacementNamed(context, '/maintenance');
      return;
    } else {
      print('   ✅ MaintenanceMode FALSE');
    }

    // Verificar actualización forzada
    remoteConfig.isForceUpdateRequired().then((forceRequired) {
      print('   🔍 isForceUpdateRequired: $forceRequired');
      if (forceRequired) {
        print('   ⚠️ ForceUpdate TRUE - navegando...');
        Navigator.pushReplacementNamed(context, '/forceUpdate');
        return;
      }
    });

    // Verificar actualización recomendada
    remoteConfig.isSoftUpdateRecommended().then((softRecommended) {
      print('   🔍 isSoftUpdateRecommended: $softRecommended');
      if (softRecommended) {
        print('   📢 SoftUpdate TRUE - mostrando diálogo...');
        _showSoftUpdateDialog(context, remoteConfig);
      }
    });
  });
}

void _handleConfigChange(BuildContext context, RemoteConfigService config) {
  // Verificar modo mantenimiento (prioridad máxima)
  if (config.isMaintenanceMode) {
    Navigator.pushReplacementNamed(context, '/maintenance');
    return;
  }

  // Verificar actualización forzada
  config.isForceUpdateRequired().then((forceRequired) {
    if (forceRequired) {
      Navigator.pushReplacementNamed(context, '/forceUpdate');
      return;
    }
  });

  // Verificar actualización recomendada
  config.isSoftUpdateRecommended().then((softRecommended) {
    if (softRecommended) {
      _showSoftUpdateDialog(context, config);
    }
  });
}

void _showSoftUpdateDialog(BuildContext context, RemoteConfigService config) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      title: Text(config.updateTitle),
      content: Text(config.updateMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Ahora no'),
        ),
        ElevatedButton(
          onPressed: () async {
            final url = Uri.parse(config.storeUrlAndroid);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
          child: Text('Actualizar'),
        ),
      ],
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
  bool? _hasSeenIntro;
  bool _isAuthCheckComplete = false;
  bool _orientationApplied = false;

  @override
  void initState() {
    super.initState();
    _loadDataPreferences();
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
  // Future<void> _initializeApp() async {
  //   // Esperar a que Flutter esté listo

  //   await _loadDataPreferences();
  //   await _initializeCatalogueProvider();
  // }

  // Future<void> _initializeCatalogueProvider() async {
  //   final context = navigatorKey.currentContext;
  //   if (context != null) {
  //     final catalogueProvider =
  //         Provider.of<CatalogueProvider>(context, listen: false);
  //     try {
  //       await catalogueProvider.initialize();
  //     } catch (e) {
  //       debugPrint('⚠️ Error inicializando catálogo: $e');
  //     }
  //   }
  // }

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
      home: SplashScreen(
        onComplete: () {
          // Cuando SplashScreen termine, mostramos la pantalla correspondiente
          _navigateToAppropriateScreen();
        },
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
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    } catch (e) {
      debugPrint('Could not apply orientation policy: $e');
    }
  }

  void _navigateToAppropriateScreen() {
    final ctx = navigatorKey.currentContext;
    if (_hasSeenIntro == null) {
      Navigator.pushReplacementNamed(ctx!, '/loading');
      return;
    }

    if (_hasSeenIntro!) {
      final authProvider = ctx!.read<AuthenticationProvider>();
      authProvider.checkAuthentication(ctx).then((_) {
        if (authProvider.isAuthenticated && authProvider.token != null) {
          Navigator.pushReplacementNamed(ctx, '/layoutPage');
        } else {
          Navigator.pushReplacementNamed(ctx, '/homePage');
        }
      });
    } else {
      Navigator.pushReplacementNamed(ctx!, '/introPage');
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
              text: "La Biblia",
              font: StylesApp(context).textStyleBody1,
            )
          ],
        ),
      ),
    );
  }
}
