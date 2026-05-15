class GraphQLConfig {

  // para emulador android
  // 'http://10.0.2.2:4020/graphql' 
  // para web
  //'http://localhost:4020'; 
  // para dispositivo físico
  //'http://192.168.1.102:4020/graphql'; 
  // para el servido Desarrollo
  // 'https://labibliapalabradevida.com:2443/dev-services/'
  // para el servidor producción
  //// 'https://labibliapalabradevida.com/services/'
  
  
  static const String baseUrl =
      'https://labibliapalabradevida.com/services/';
  static const String urlServidor = 'https://labibliapalabradevida.com/';
  static const urlSocketDev = 'wss://labibliapalabradevida.com:2443';
  static const urlSocketProd = 'wss://labibliapalabradevida.com:2443'; //'wss://labibliapalabradevida.com';
  static const String authToken = '';
  static const bool development = false;
  static const String urlApkRadio = 'https://apk.e-droid.net/apk/app3557953-xlahe3.apk?v=5';
  static const String clientId = '945681325893-14cjnnp2o5kctmlpti54nctcacdt1h00.apps.googleusercontent.com';// '823422522259-lsaj5empb8t54pims7m727krgrcfu6lf.apps.googleusercontent.com';
  static const String serverClientId = '945681325893-14cjnnp2o5kctmlpti54nctcacdt1h00.apps.googleusercontent.com';//'945681325893-ckla49hrnakacrpc9fc21vie6ub9o9o3.apps.googleusercontent.com';
  static const String emailContact = 'labibliarenuevodevida@gmail.com';
  static const String stripePaymentLink = "https://buy.stripe.com/test_xxxxxxxxxxxx";

   // ============================================
  // CONFIGURACIÓN DE LA LIBRERÍA
  // ============================================
  // Backend de la librería (GraphQL + REST)
  // Para desarrollo local:
  // static const String libreriaBaseUrl = 'http://localhost:3001';
  
  // Para dispositivo físico (USB debugging):
  // static const String libreriaBaseUrl = 'http://192.168.1.X:3001'; // Reemplaza X con tu IP
  
  // Para servidor de desarrollo:
  // static const String libreriaBaseUrl = 'https://labibliapalabradevida.com:2443/libreria/';
    // Para producción1ºring libreriaBaseUrl = 'https://labibliapalabradevida.com/libreria/';
  
  // Para emulador Android (desde Android Studio):
  static const String libreriaBaseUrl = 'http://10.0.2.2:3001';
  
  
  static const String libreriaGraphQLEndpoint = '$libreriaBaseUrl/graphql';
  static const String libreriaRestEndpoint = '$libreriaBaseUrl/api';
}
