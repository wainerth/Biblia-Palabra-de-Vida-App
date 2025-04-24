import 'dart:async';
import 'dart:io';

import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';

import 'package:biblia_palabra_de_vida_app/models/models.dart';

import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';

import 'package:flutter/foundation.dart';

import 'package:graphql_flutter/graphql_flutter.dart';

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

    // carga los paises
    await _loadCountries();
    // carga el sexo
    await _loadSex();
    // carga las versiones de la biblia
    await _loadVersions();

    // carga las iglesias
    await _loadChurches();

    // carga los ligas
    await _loadLeagues();

    // carga las configuraciones
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
      if (kDebugMode) {
        print("countries llamado ");
      }
      allCountries = (data['getAllCountries'] as List)
          .map((i) => Country.fromJson(i))
          .toList();

      notifyListeners();
    } on TimeoutException catch (e) {
      if (kDebugMode) {
        print('Timeout: $e');
      }
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
            description
            maxMembers
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
      if (kDebugMode) {
        print(allConfig);
      }

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to obtain getConfigurations $e');
    }
  }
}
