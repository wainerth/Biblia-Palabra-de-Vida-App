import 'package:biblia_palabra_de_vida_app/config/api_config.dart';

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

  static String get endpoint {
    if (ApiConfig.development) {
      return 'https://labibliapalabradevida.com:2443/dev-services/';
    } else {
      return 'https://labibliapalabradevida.com/services/';
    }
  }
static String get endpointLibrary {
  return 'http://10.0.2.2:3001/graphql';

}
 static String get webSocketEndpoint {
    if (ApiConfig.development) {
      return 'wss://labibliapalabradevida.com:2443';
    } else {
      return 'wss://labibliapalabradevida.com';
    }
  }
 static String get webSocketPath {
    if (ApiConfig.development) {
      return '/socket.io-dev';
    } else {
      return '/socket.io';
    }
  }
}

