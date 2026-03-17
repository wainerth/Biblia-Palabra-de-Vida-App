import 'dart:async';
import 'dart:io' show Platform;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  bool _isInitialized = false;
  VoidCallback? _onConfigUpdated;
  VoidCallback? _onNavigateToAppropriateScreen;

  // Control de actualizaciones
  Timer? _pollingTimer;
  bool _isDisposed = false;
  String _lastFetchedValues = '';

  // Valores cacheados
  String get minimumVersion => _remoteConfig.getString('minimum_version');
  bool get isForceUpdate => _remoteConfig.getBool('force_update');
  bool get isMaintenanceMode => _remoteConfig.getBool('maintenance_mode');
  String get updateTitle => _remoteConfig.getString('update_title');
  String get updateMessage => _remoteConfig.getString('update_message');
  String get maintenanceTitle => _remoteConfig.getString('maintenance_title');
  String get maintenanceMessage =>
      _remoteConfig.getString('maintenance_message');
  String get storeUrlAndroid => _remoteConfig.getString('store_url_android');
  String get latestVersion => _remoteConfig.getString('latest_version');

  Future<void> initialize({VoidCallback? onConfigUpdated}) async {
    if (_isInitialized) return;

    try {
      _onConfigUpdated = onConfigUpdated;
      _isDisposed = false;

      // Configuración estándar
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval:
            const Duration(minutes: 1), // 1 minuto para pruebas
      ));

      await _remoteConfig.setDefaults({
        'minimum_version': '1.0.0',
        'latest_version': '1.0.0',
        'force_update': false,
        'maintenance_mode': false,
        'update_title': 'Actualización disponible',
        'update_message': 'Hay una nueva versión de la app disponible',
        'maintenance_title': 'Mantenimiento',
        'maintenance_message':
            'Estamos mejorando la aplicación para ofrecerte una mejor experiencia',
        'store_url_android': 'market://details?id=com.tuapp',
      });

      // Fetch inicial
      await _remoteConfig.fetchAndActivate();
      _printAllParameters();
      _saveCurrentValues();

      // Estrategia según plataforma
      if (Platform.isIOS) {
        // En iOS intentamos tiempo real (funciona bien)
        _setupRealtimeListener();
      } else {
        // En Android usamos polling (más estable)
        if (kDebugMode) {
          print(
              '📱 Android detectado - usando polling en lugar de tiempo real');
        }
      }

      // En ambas plataformas, iniciamos polling como respaldo
      _startPolling();

      _isInitialized = true;
      if (kDebugMode) {
        print('✅ Remote Config inicializado correctamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error inicializando Remote Config: $e');
      }
    }
  }

  /// Listener de tiempo real (solo iOS)
  void _setupRealtimeListener() {
    try {
      if (kDebugMode) {
        print('📡 Configurando listener en tiempo real...');
      }

      _remoteConfig.onConfigUpdated.listen((event) async {
        if (kDebugMode) {
          print('🎯 ¡Evento en tiempo real recibido!');
        }
        await _remoteConfig.activate();
        _checkForChanges();
      }, onError: (error) {
        if (kDebugMode) {
          print('⚠️ Error en tiempo real: $error - usando polling');
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ No se pudo establecer tiempo real: $e');
      }
    }
  }

  void setNavigationCallback(VoidCallback callback) {
    _onNavigateToAppropriateScreen = callback;
  }

  /// Polling periódico (funciona en todas plataformas)
  void _startPolling() {
    _pollingTimer?.cancel();

    // Polling cada 30 segundos para pruebas (en producción podrían ser 2-5 minutos)
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      try {
        await _remoteConfig.fetch();
        final activated = await _remoteConfig.activate();

        if (activated) {
          if (kDebugMode) {
            print('🔄 Polling: Nuevos valores detectados!');
          }
          _printAllParameters();
          _checkForChanges();
        }
      } catch (e) {
        // Silenciar errores de polling para no saturar logs
      }
    });

    if (kDebugMode) {
      print('⏱️ Polling iniciado (cada 30 segundos)');
    }
  }

  /// Verificar si hubo cambios significativos
  void _checkForChanges() {
    final currentValues = _getCurrentValuesString();

    if (currentValues != _lastFetchedValues) {
      if (kDebugMode) {
        print('📢 Cambios detectados en configuración');
      }
      _lastFetchedValues = currentValues;

      if (_onConfigUpdated != null && !_isDisposed) {
        _onConfigUpdated!();
      }
    }
  }

  String _getCurrentValuesString() {
    return 'min:$minimumVersion|latest:$latestVersion|force:$isForceUpdate|maintenance:$isMaintenanceMode';
  }

  void _saveCurrentValues() {
    _lastFetchedValues = _getCurrentValuesString();
  }

  void _printAllParameters() {
    if (kDebugMode) {
      print('📊 VALORES ACTUALES:');
      print('  minimum_version: $minimumVersion');
      print('  latest_version: $latestVersion');
      print('  force_update: $isForceUpdate');
      print('  maintenance_mode: $isMaintenanceMode');
      print('  update_title: $updateTitle');
      print('  update_message: $updateMessage');
    }
  }

  /// Método público para forzar refresh manual
  Future<void> refreshConfig() async {
    if (kDebugMode) {
      print('🔄 Forzando refresh manual...');
    }
    try {
      await _remoteConfig.fetch();
      final activated = await _remoteConfig.activate();
      if (activated) {
        if (kDebugMode) {
          print('✅ Nuevos valores activados');
        }
        _printAllParameters();
        _checkForChanges();
      } else {
        if (kDebugMode) {
          print('ℹ️ Sin cambios nuevos');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error en refresh manual: $e');
      }
    }
  }

  Future<String> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  int compareVersions(String current, String minimum) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> minimumParts = minimum.split('.').map(int.parse).toList();

    while (currentParts.length < 3) {
      currentParts.add(0);
    }
    while (minimumParts.length < 3) {
      minimumParts.add(0);
    }

    for (int i = 0; i < 3; i++) {
      if (currentParts[i] < minimumParts[i]) return -1;
      if (currentParts[i] > minimumParts[i]) return 1;
    }
    return 0;
  }

  Future<bool> isForceUpdateRequired() async {
    final currentVersion = await getCurrentVersion();
    final comparison = compareVersions(currentVersion, latestVersion);
    return comparison < 0 && isForceUpdate;
  }

  Future<bool> isSoftUpdateRecommended() async {
    final currentVersion = await getCurrentVersion();
    final forceRequired = await isForceUpdateRequired();
    if (forceRequired) return false;
    final comparison = compareVersions(currentVersion, latestVersion);
    return comparison < 0;
  }

  void dispose() {
    _isDisposed = true;
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }
}
