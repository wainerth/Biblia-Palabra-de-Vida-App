import 'dart:async';
import 'dart:io';

import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';

import 'package:biblia_palabra_de_vida_app/models/models.dart';

import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';

import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CatalogueProvider extends ChangeNotifier {
  late GraphQLClient _client;
  late Map<String, dynamic> allConfig;
  List<Country> allCountries = []; // Inicializa las listas
  List<Church> allChurches = [];
  List<League> allLeagues = [];
  List<CourseModel> allCourses = [];

  CatalogueProvider() {
    initialize(); // Llama a la función de initialize
  }

  Future<void> initialize() async {
    _client = createClient();
    await _loadCountries();

    await _loadSex();

    await _loadVersions();

    await _loadChurches();

    await _loadLeagues();
    await _getConfigurations();
  }

  Future<void> _loadCountries() async {
    QueryOptions options = QueryOptions(
      operationName: "GetAllCountries",
      document: gql(r'''
      query GetAllCountries {
        getAllCountries {
          id
          country
          country_code
        }
      }
      '''),
      fetchPolicy: FetchPolicy.noCache,
    );

    try {
      final QueryResult result = await _client.query(options);

      if (result.hasException) {
       final response = ResponseData.fromQueryResult(result);
        throw Exception('Failed to obtain Countries ${response.error}');
      }

      final data = result.data;

      if (data == null || data['getAllCountries'] == null) {
        throw Exception('obtain Countries no data');
      }
      print("countries llamado ");
      allCountries = (data['getAllCountries'] as List)
          .map((i) => Country.fromJson(i))
          .toList();

      notifyListeners();
    } on TimeoutException catch (e) {
      print('Timeout: $e');
      throw Exception('obtain Countries Timeout de conexión $e');
    } catch (e) {
      // More specific error handling if needed:
      if (e is TimeoutException) {
        throw Exception("Request timed out");
      } else if (e is SocketException) {
        throw Exception("No Internet Connection");
      } else if (e is FormatException) {
        // Example: JSON parsing error
        throw Exception("Invalid data format");
      } else {
        throw Exception("Failed to obtain Countries : $e"); // Generic error
      }
    }
  }

  Future<void> _loadSex() async {
    // Lógica para cargar la lista de opciones de sexo

    // Ejemplo:

    // final sexo = await _obtenerOpcionesSexoDesdeBaseDeDatos();

    // ...
  }

  Future<void> _loadVersions() async {
    // Lógica para cargar la lista de versiones

    // Ejemplo:

    // final versiones = await _obtenerVersionesDesdeAPI();

    // ...
  }

  Future<void> _loadChurches() async {
    QueryOptions options = QueryOptions(
      operationName: "GetAllChurches",
      document: gql(r'''
      query GetAllChurches {
          getAllChurches {
            id
            name
          }
        }
      '''),
      fetchPolicy: FetchPolicy.noCache,
    );

    try {
      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        final response = ResponseData.fromQueryResult(result);
        throw Exception('Failed to obtain Churches ${response.error}');
      }

      final data = result.data;

      if (data == null || data['getAllChurches'] == null) {
        throw Exception('obtain Churches no data');
      }

      allChurches = (data['getAllChurches'] as List)
          .map((i) => Church.fromJson(i))
          .toList();

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to obtain Churches $e');
    }
  }

  Future<void> _loadLeagues() async {
    QueryOptions options = QueryOptions(
      operationName: "GetAllLeagues",
      document: gql(r'''
     query GetAllLeagues {
          getAllLeagues {
            id
            name
            colorFront
            colorBack
            status
            img {
              urlImg
            }
          }
        }
      '''),
      fetchPolicy: FetchPolicy.noCache,
    );

    try {
      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        final response = ResponseData.fromQueryResult(result);
        throw Exception('Failed to obtain leagues ${response.error}');
      }

      final data = result.data;

      if (data == null || data['getAllLeagues'] == null) {
        throw Exception('obtain leagues no data');
      }

      allLeagues = (data['getAllLeagues'] as List)
          .map((i) => League.fromJson(removeTypename(i)))
          .toList();

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to obtain leagues $e');
    }
  }

  Future<void> _getConfigurations() async {
    QueryOptions options = QueryOptions(
      operationName: "GetConfigurations",
      document: gql(r'''
        query GetConfigurations {
      getConfigurations
    }
      '''),
      fetchPolicy: FetchPolicy.noCache,
    );

    try {
      final QueryResult result = await _client.query(options);

      if (result.hasException) {
        throw Exception('Failed to obtain getConfigurations');
      }

      final data = result.data;

      if (data == null || data['getConfigurations'] == null) {
        throw Exception('Failed to obtain getConfigurations');
      }

      allConfig =
          Map<String, dynamic>.from(removeTypename(data['getConfigurations']));
      print(allConfig);

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to obtain getConfigurations $e');
    }
  }
} 

// import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
// import 'package:biblia_palabra_de_vida_app/models/models.dart';
// import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
// import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class CatalogueProvider extends ChangeNotifier {
  // late GraphQLClient _client;
  // List<Country> allCountries = []; // Inicializa las listas
  // List<Church> allChurches = [];
  // List<League> allLeagues = [];
  // List<CourseModel> allCourses = [];

  // CatalogueProvider() {
  //   _initialize(); // Llama a la función de inicialización
  // }

//   Future<void> _initialize() async {
//     try {
//       await _loadData(); // Carga todos los datos
//       notifyListeners(); // Notifica a los listeners una vez que todo está cargado
//     } catch (e) {
//       // Manejo de errores centralizado
//       print('Error initializing CatalogueProvider: $e');
//       // Puedes mostrar un mensaje de error en la UI si lo deseas
//     }
//   }

//   Future<void> _loadData() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? userToken = prefs.getString('userToken');
//     _client = createClient();

//     await Future.wait([
//       // Ejecuta las cargas en paralelo
//       _loadFromGraphQL<Country>(
//         client: createClient(),
//         queryName: "GetAllCountries",
//         query: r'''
//           query GetAllCountries {
//             getAllCountries {
//               id
//               country
//               country_code
//             }
//           }
//         ''',
//         fromJson: (i) =>
//             i != null ? Country.fromJson(i) : null, // Manejo de null
//         resultList: allCountries, // Actualiza la lista correspondiente
//       ),

//       _loadFromGraphQL<Church>(
//         client: createClient(authToken: userToken),
//         queryName: "GetAllChurches",
//         query: r'''
//           query GetAllChurches {
//             getAllChurches {
//               id
//               name
//             }
//           }
//         ''',
//         fromJson: (i) => i != null ? Church.fromJson(i) : null,
//         resultList: allChurches,
//       ),
//       // _loadFromGraphQL<League>(
//       //   client: createClient(authToken: userToken),
//       //   queryName: "GetAllLeagues",
//       //   query: r'''
//       //     query GetAllLeagues {
//       //       getAllLeagues {
//       //         id
//       //         name
//       //         minMembers
//       //         maxMembers
//       //         status
//       //         img {
//       //           urlImg
//       //         }
//       //       }
//       //     }
//       //   ''',
//       //   fromJson: (i) => i != null ? League.fromJson(removeTypename(i)) : null,
//       //   resultList: allLeagues,
//       // ),
//       // _loadSex(),  // Implementa estas funciones si son necesarias
//       // _loadVersions(),
//     ]);
//   }

//   Future<void> _loadFromGraphQL<T>({
//     required GraphQLClient client,
//     required String queryName,
//     required String query,
//     required T? Function(Map<String, dynamic>?) fromJson,
//     required List<T> resultList,
//   }) async {
//     QueryOptions options = QueryOptions(
//       operationName: queryName,
//       document: gql(query),
//       fetchPolicy: FetchPolicy.noCache,
//     );

//     try {
//       final QueryResult result = await _client.query(options);
//       if (result.hasException) {
//         throw Exception('Failed to obtain $queryName: ${result.exception}');
//       }

//       final data = result.data;
//       if (data == null || data[queryName] == null) {
//         throw Exception('Failed to obtain $queryName: Data is null');
//       }

//       resultList.clear(); // Limpia la lista antes de agregar nuevos elementos
//       (data[queryName] as List).forEach((i) {
//         final item = fromJson(i);
//         if (item != null) {
//           resultList.add(item);
//         }
//       });
//     } catch (e) {
//       print('Error loading $queryName: $e'); // Imprime el error
//       rethrow; // Re-lanza la excepción para que se maneje en _initialize
//     }
//   }
// }
