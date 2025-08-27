import 'dart:convert';
import 'dart:io';

import 'package:biblia_palabra_de_vida_app/main.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';

class SocketClientProvider with ChangeNotifier {
  IO.Socket? _socket;
  bool _isConnected = false;
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  List<NotificationModel> _notifications = [];
  IO.Socket? get socket => _socket;
  bool get isConnected => _isConnected;

  List<NotificationModel> get notifications => _notifications;

  @pragma('vm:entry-point')
  static void backgroundNotificationHandler(NotificationResponse response) {
    if (kDebugMode) {
      print("Notificación en segundo plano: ${response.payload}");
    }
    
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
        onDidReceiveBackgroundNotificationResponse: backgroundNotificationHandler // _handleNotificationClick(response.payload);
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
          presentAlert: true,
          presentBadge: true,
          presentSound: true
          );
     
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
        final routeInfo = getRouterScreen(notification.model);

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
    _socket = IO.io(
      'https://labibliapalabradevida.com',
      IO.OptionBuilder()
          .setTransports(['websocket']) // transports
          .setPath('/socket.io') // path
          .setQuery({
            'deviceId': deviceId,
            'userId': userId,
            'username': username,
            'email': email,
          }) // query
          .enableReconnection() // reconnection
          .setReconnectionDelay(1000) // reconnectionDelay
          .setReconnectionDelayMax(5000) // reconnectionDelayMax
          .setReconnectionAttempts(3) // maxReconnectionAttempts
          .setTimeout(10000) // timeout
          .enableForceNew() // forceNew
          .build(),
    );

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
      notifyListeners();
      if (kDebugMode) {
        print('Socket disconnected');
      }
    });

    _socket?.onError((error) {
      if (kDebugMode) {
        print('Socket error: $error');
      }
    });
  }

  // Método para desconectar
  void disconnectSocket() {
    if (_socket != null) {
      _socket?.disconnect();
      _socket?.dispose();
      _socket = null;
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

  @override
  void dispose() {
    disconnectSocket();
    super.dispose();
  }
}
