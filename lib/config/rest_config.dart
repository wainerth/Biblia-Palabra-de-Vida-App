import 'package:biblia_palabra_de_vida_app/config/api_config.dart';

class RestConfig {

   // Backend de la librería (GraphQL + REST)
  // Para desarrollo local:
  // static const String libreriaBaseUrl = 'http://localhost:3001';

  // Para dispositivo físico (USB debugging):
  // static const String libreriaBaseUrl = 'http://192.168.1.X:3001'; // Reemplaza X con tu IP


   static String get baseUrl {
    if (ApiConfig.development) {
      return 'http://10.0.2.2:3001/api';
      // return 'http://192.168.1.102:3001/api'; // Dispositivo físico
    } else {
      return 'https://labibliapalabradevida.com/libreria/api';
    }
  }
  
  // Endpoints específicos
  static const String cart = '/cart';
  static const String cartItems = '/cart/items';
  static const String orders = '/orders';
  static const String books = '/books';
}