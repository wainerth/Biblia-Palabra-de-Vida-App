import 'dart:convert';
import 'package:biblia_palabra_de_vida_app/main.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = 
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await _setupFirebase();
    await _setupLocalNotifications();
    await _requestPermissions();
    await _setupInterceptors();
  }

  static Future<void> _setupFirebase() async {
    await Firebase.initializeApp();
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );
    print('Permisos de notificación: ${settings.authorizationStatus}');
  }

  static Future<void> _setupInterceptors() async {
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
    FirebaseMessaging.instance.getInitialMessage().then(_handleInitialMessage);
    
    // Escuchar refresco de token
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('Nuevo token FCM: $newToken');
      _sendTokenToServer(newToken);
    });
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    print('Notificación en primer plano: ${message.messageId}');
    _showLocalNotification(message);
  }

  static void _handleBackgroundMessage(RemoteMessage message) {
    print('Notificación en segundo plano: ${message.messageId}');
    _navigateToScreen(message);
  }

  static void _handleInitialMessage(RemoteMessage? message) {
    if (message != null) {
      print('Notificación con app cerrada: ${message.messageId}');
      _navigateToScreen(message);
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'Notificaciones importantes',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      message.notification?.title ?? 'Nueva notificación',
      message.notification?.body ?? '',
      details,
      payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
    );
  }

  static void _navigateToScreen(RemoteMessage message) {
    final data = message.data;
    if (data.isNotEmpty) {
      // Usar tu función getRouterScreen existente
      final routeInfo = getRouterScreen(data['model'], data['variables']);
      
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
    }
  }

  static Future<String?> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('Error obteniendo token FCM: $e');
      return null;
    }
  }

  static Future<void> _sendTokenToServer(String token) async {
    // Implementar envío de token a tu backend
    print('Enviando token al servidor: $token');
    // Ejemplo: await apiService.updateFcmToken(token);
  }
}