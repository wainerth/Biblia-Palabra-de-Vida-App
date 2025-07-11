import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/foundation.dart';

class SocketClientProvider with ChangeNotifier {
  IO.Socket? _socket;
  bool _isConnected = false;

  IO.Socket? get socket => _socket;
  bool get isConnected => _isConnected;
  List<NotificationModel> notifications = [
    // NotificationModel(
    //     id: "1",
    //     title: "Notificación de Prueba",
    //     message: "El mensaje d ela Notificación",
    //     isRead: false,
    //     actionUrl: "/course",
    //     actionLabel: "Courses",
    //     notificationType: "Creación course",
    //     notificationTypeName: "Creación course",
    //     imageUrl: "/course/imagen.jpeg",
    //     createdAt: "2025-07-09 T00:00:00",
    //     ),
    // NotificationModel(
    //     id: "2",
    //     title: "Notificación de Prueba 2",
    //     message: "El mensaje d ela Notificación de la prueba 2",
    //     isRead: false,
    //     actionUrl: "/course",
    //     actionLabel: "Courses",
    //     notificationType: "Creación course",
    //     notificationTypeName: "Creación course",
    //     imageUrl: "/course/imagen.jpeg",
    //     createdAt: "2025-07-09 T00:00:00",
    //     ),
    // NotificationModel(
    //     id: "3",
    //     title: "Notificación de Prueba 3",
    //     message: "El mensaje d ela Notificación de la Prueba 3",
    //     isRead: true,
    //     actionUrl: "/course",
    //     actionLabel: "Courses",
    //     notificationType: "Creación course",
    //     notificationTypeName: "Creación course",
    //     imageUrl: "/course/imagen.jpeg",
    //     createdAt: "2025-07-09 T00:00:00",
    //     ),
  ];

  // Método para conectar al socket
  void connectSocket({
    required String deviceId,
    required String userId,
    required String username,
    required String email,
  }) {
    // Desconectar si ya hay una conexión existente
    disconnectSocket();

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
    print(eventName);
    _socket?.on(eventName, callback);
  }

  // Emitir eventos
  void emitEvent(String eventName, dynamic data) {
    print(eventName);
    _socket?.emit(eventName, data);
  }
  
  @override
  void dispose() {
    disconnectSocket();
    super.dispose();
  }
}
