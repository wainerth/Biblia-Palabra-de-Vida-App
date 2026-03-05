import 'dart:ui';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  bool _isInitialized = false;
  VoidCallback? _onConfigUpdated;

  // Valores cacheados para acceso rapido
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

  /// Inicializar Remote Config
  Future<void> initialize({VoidCallback? onConfigUpdated}) async {
    if (_isInitialized) return;

    try {
      _onConfigUpdated = onConfigUpdated;

      // Configurar tiempo de fetch y caché [citation:5][citation:7]
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: const Duration(hours: 0),
      ));

      // Valores por defecto
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
      // 👇 ACTIVAR REALTIME REMOTE CONFIG
      _setupRealtimeListener();

      // Fetch inicial
      await _remoteConfig.fetchAndActivate();

      _printAllParameters();

      _isInitialized = true;
      print('✅ Remote Config inicializado correctamente');
    } catch (e) {
      print('❌ Error inicializando Remote Config: $e');
      // La app usará los valores por defecto
    }
  }

  /// 🔥 NUEVO: Configurar listener en tiempo real
  void _setupRealtimeListener() {
    try {
      print('📡 [1] Intentando configurar listener en tiempo real...');

      _remoteConfig.onConfigUpdated.listen((event) async {
        print('🎯 [2] ¡EVENTO RECIBIDO! Timestamp: ${DateTime.now()}');
        print('   Datos del evento: $event');

        // Verificar estado antes de activar
        // print('   Estado antes de activate: ${_remoteConfig.info}');

        // Activar los nuevos valores
        await _remoteConfig.activate();
        print('   ✅ Valores activados');

        // Mostrar los nuevos valores
        _printAllParameters();

        // Verificar si hay callback
        if (_onConfigUpdated != null) {
          print('   📢 Ejecutando callback...');
          _onConfigUpdated!();
        } else {
          print('   ⚠️ _onConfigUpdated es null');
        }

        _handleConfigUpdate();
      }, onError: (error) {
        print('❌ Error en listener: $error');
      }, onDone: () {
        print('📡 Listener cerrado');
      });

      print('✅ [3] Listener configurado correctamente');

      // Verificar el stream
      print('   Stream exists: ${_remoteConfig.onConfigUpdated != null}');
    } catch (e, stack) {
      print('❌ Error configurando Realtime listener: $e');
      print('Stack: $stack');
    }
  }

  /// 🔥 NUEVO: Manejar cambios específicos
  void _handleConfigUpdate() {
    // Ejemplo: Si cambia maintenance_mode, actuar inmediatamente
    if (isMaintenanceMode) {}

    // Ejemplo: Si cambia force_update, verificar si aplica
    if (isForceUpdate) {
      print('⚠️ Actualización forzada activada en tiempo real');
      // Podrías verificar la versión actual y forzar update si es necesario
    }
  }

  Stream<bool> get onConfigChanged =>
      _remoteConfig.onConfigUpdated.map((event) {
        return true; // Emite true cada vez que hay cambios
      });

  void _printAllParameters() {
    print('📊 [DEBUG] VALORES ACTUALES:');
    print('  minimum_version: ${_remoteConfig.getString('minimum_version')}');
    print('  latest_version: ${_remoteConfig.getString('latest_version')}');
    print('  force_update: ${_remoteConfig.getBool('force_update')}');
    print('  maintenance_mode: ${_remoteConfig.getBool('maintenance_mode')}');
    print('  update_title: ${_remoteConfig.getString('update_title')}');
    print('  update_message: ${_remoteConfig.getString('update_message')}');
  }

  /// Refrescar configuración manualmente
  Future<void> refreshConfig() async {
    try {
      await _remoteConfig.fetchAndActivate();
      print('🔄 Remote Config refrescado');
    } catch (e) {
      print('Error refrescando Remote Config: $e');
    }
  }

  /// Obtener versión actual de la app
  Future<String> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// Comparar versiones (retorna: -1 si current < min, 0 si igual, 1 si current > min)
  int compareVersions(String current, String minimum) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> minimumParts = minimum.split('.').map(int.parse).toList();

    // Asegurar que ambas listas tengan 3 elementos
    while (currentParts.length < 3) currentParts.add(0);
    while (minimumParts.length < 3) minimumParts.add(0);

    for (int i = 0; i < 3; i++) {
      if (currentParts[i] < minimumParts[i]) return -1;
      if (currentParts[i] > minimumParts[i]) return 1;
    }
    return 0;
  }

  /// Verificar si requiere actualización forzada
  Future<bool> isForceUpdateRequired() async {
    final currentVersion = await getCurrentVersion();
    final comparison = compareVersions(currentVersion, minimumVersion);
    return comparison < 0 && isForceUpdate;
  }

  /// Verificar si hay actualización recomendada
  Future<bool> isSoftUpdateRecommended() async {
    final currentVersion = await getCurrentVersion();
    final forceRequired = await isForceUpdateRequired();

    if (forceRequired)
      return false; // Si es forzada, no mostrar como "recomendada"

    final comparison = compareVersions(currentVersion, latestVersion);
    return comparison < 0; // current < latest
  }
}
