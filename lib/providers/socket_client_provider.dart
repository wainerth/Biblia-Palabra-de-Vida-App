import 'dart:convert';
import 'dart:io';

import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/main.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/services/fcm_service.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SocketClientProvider with ChangeNotifier, WidgetsBindingObserver {
  IO.Socket? _socket;
  bool _isConnected = false;
  bool _initialized = false;
  bool get isInitialized => _initialized;
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  List<NotificationModel> _notifications = [];
  IO.Socket? get socket => _socket;
  bool get isConnected => _isConnected;

  List<NotificationModel> get notifications => _notifications;

  String? _fcmToken;

  @pragma('vm:entry-point')
  static void backgroundNotificationHandler(NotificationResponse response) {
    if (kDebugMode) {
      print("Notificación en segundo plano: ${response.payload}");
    }
  }

  void initializeObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  // Método para inicializar TODO el sistema de notificaciones
  Future<void> initializeNotificationSystem() async {
    await FCMService.initialize();
    await initializeNotifications(); // Tu método existente

    // Obtener token FCM
    _fcmToken = await FCMService.getFCMToken();
    print('Token FCM obtenido: $_fcmToken');

    // if (_fcmToken != null) {
    //   _sendFcmTokenToServer(_fcmToken!);
    // }
  }

// Método para inicializar notificaciones locales
  Future<void> initializeNotifications() async {
    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
              requestAlertPermission: true,
              requestBadgePermission: true,
              requestSoundPermission: true);

      final InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await notificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (response) {
          _handleNotificationClick(response.payload);
        },
        onDidReceiveBackgroundNotificationResponse:
            backgroundNotificationHandler // _handleNotificationClick(response.payload);
        ,
      );

      // Solicitar permisos explícitamente para iOS
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await notificationsPlugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(
              alert: true,
              badge: true,
              sound: true,
            );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing notifications: $e');
      }
    }
  }

  // Método para mostrar notificaciones
  Future<void> showNotification(NotificationModel notification) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'notifications_channel',
        'Notificaciones',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        visibility: NotificationVisibility.public,
        // sound: RawResourceAndroidNotificationSound('turtle_sound'),
        // styleInformation: BigTextStyleInformation(''),
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
          presentAlert: true, presentBadge: true, presentSound: true);

      await notificationsPlugin.show(
        int.tryParse(notification.id!)!, // Usamos el ID como notificationId
        notification.title,
        notification.message,
        const NotificationDetails(
          android: androidDetails,
          iOS: iosDetails,
        ),
        payload: jsonEncode(
            notification.toJson()), // Usamos actionUrl para redirección
      );
      if (kDebugMode) {
        print('Notification shown successfully with ID: ${notification.id!}');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error showing notification: $e');
        print('Stack trace: $stackTrace');
      }
    }
  }

  // Manejar clic en notificación
  void _handleNotificationClick(String? payload) {
    try {
      if (payload != null && payload.isNotEmpty) {
        if (kDebugMode) {
          print('Notification payload received: $payload');
        }

        // Deserializable el payload
        final notificationData = jsonDecode(payload);
        final notification = NotificationModel.fromJson(notificationData);

        // Navegación más robusta
        final routeInfo =
            getRouterScreen(notification.model, notification.variables);

        // WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigatorKey.currentState != null) {
          if (routeInfo.arguments != null) {
            navigatorKey.currentState?.pushNamed(
              routeInfo.routeName,
              arguments: routeInfo.arguments,
            );
          } else {
            navigatorKey.currentState?.pushNamed(routeInfo.routeName);
          }
        }
        // });
      } else {
        if (kDebugMode) {
          print('Notification clicked but payload was empty');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error handling notification click: $e');
      }
    }
  }

  void _showPermissionExplanation() {
    navigatorKey.currentState?.push(
      DialogRoute(
        context: navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          title: const Text('Permiso requerido'),
          content: const Text(
              'Necesitamos permiso para mostrarte notificaciones importantes.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings(); // Abre ajustes de la app
              },
              child: const Text('Abrir ajustes'),
            ),
          ],
        ),
      ),
    );
  }

  void cleanNotification() {
    _notifications.clear();
  }

  void addNotification(NotificationModel notification) {
    _notifications.add(notification);
    notifyListeners(); // ¡Esto es crucial!
  }

  // Método para conectar al socket
  void connectSocket({
    required String deviceId,
    required String userId,
    required String username,
    required String email,
  }) async {
    _initialized = true;
    initializeObserver();
    // Inicializar sistema de notificaciones primero
    await initializeNotificationSystem();

    // Desconectar si ya hay una conexión existente
    disconnectSocket();

    if (Platform.isAndroid) {
      final deviceInfoPlugin = DeviceInfoPlugin();
      final androidInfo = await deviceInfoPlugin.androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        final status = await Permission.notification.request();
        if (status.isDenied) {
          // Opcional: Mostrar explicación al usuario
          _showPermissionExplanation();
        }
      }
    }

    // Configuración del socket similar a tu implementación en React
    _socket = IO.io('https://labibliapalabradevida.com', {
      'transports': ['polling'], // ✅ Comenzar con polling
      'upgrade': true, // ✅ Permitir upgrade a websocket
      'path': '/socket.io${GraphQLConfig.development ? '-dev' : ''}', // Ajusta el path si es necesario
      'query': {
        'deviceId': deviceId,
        'userId': userId,
        'username': username,
        'email': email,
        'fcmToken': _fcmToken ?? '',
        'EIO': '4', // ✅ Forzar Engine.IO v4
      },
      'forceNew': true,
      'reconnection': true,
      'timeout': 10000,
    });

    // Manejar eventos de conexión
    _socket?.onConnect((_) {
      _isConnected = true;
      notifyListeners();
      if (kDebugMode) {
        print('Socket connected');
      }
    });

    _socket?.onDisconnect((_) {
      _isConnected = false;
      _initialized = false;
      notifyListeners();
      if (kDebugMode) {
        print('Socket disconnected');
      }
    });

    _socket?.onError((error) {
      if (kDebugMode) {
        print('Socket error: $error');
        _initialized = false;
      }
    });
    // Escuchar evento para notificaciones push
    _socket?.on('push_notification', (data) {
      _handlePushNotification(data);
    });
  }

  // Método para desconectar
  void disconnectSocket() {
    if (_socket != null) {
      _socket?.disconnect();
      _socket?.dispose();
      // _socket = null;
      _isConnected = false;
      notifyListeners();
    }
  }

  // Escuchar eventos específicos
  void listenToEvent(String eventName, Function(dynamic) callback) {
    if (kDebugMode) {
      print(eventName);
    }
    _socket?.on(eventName, callback);
    notifyListeners();
  }

  // Emitir eventos
  void emitEvent(String eventName, dynamic data) {
    if (kDebugMode) {
      print(eventName);
    }
    _socket?.emit(eventName, data);
  }

  void _handlePushNotification(dynamic data) {
    try {
      final notification = NotificationModel.fromJson(data);
      // Mostrar notificación local
      showNotification(notification);

      // También agregar a la lista de notificaciones
      addNotification(notification);
    } catch (e) {
      if (kDebugMode) {
        print('Error manejando notificación push: $e');
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disconnectSocket();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kDebugMode) {
      print('AppLifecycleState changed: $state');
    }

    switch (state) {
      case AppLifecycleState.paused: // ✅ App va a segundo plano o se cierra
        disconnectSocket();
        break;

      case AppLifecycleState
            .detached: // ✅ App siendo cerrada (poco confiable pero por si acaso)
        disconnectSocket();
        break;

      case AppLifecycleState.resumed: // ✅ App vuelve a primer plano
        _tryReconnect();
        break;

      case AppLifecycleState.inactive: // ⏸️ Estado intermedio
        break;
      case AppLifecycleState.hidden: // 🆕 Nuevo estado en Flutter 3.0+
        disconnectSocket();

        break;
    }

    super.didChangeAppLifecycleState(state); // ✅ IMPORTANTE
  }

  void _tryReconnect() {
    if (_socket != null && !_isConnected) {
      if (kDebugMode) {
        print('🔄 Intentando reconexión automática...');
      }

      try {
        // Disconnect primero para limpiar
        _socket?.disconnect();

        // Reconectar después de un breve delay
        Future.delayed(Duration(milliseconds: 1000), () {
          _socket?.connect();
        });
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error en reconexión: $e');
        }
      }
    }
  }
}
