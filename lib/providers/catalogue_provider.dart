import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class CatalogueProvider extends ChangeNotifier {
  late GraphQLClient _client;
  late Map<String, dynamic> allConfig;
  List<Country> allCountries = [];
  List<AreaCode> allAreasCode = [];
  List<Church> allChurches = [];
  List<League> allLeagues = [];
  List<VersionModel> allBibleVersion = [];

  bool _isInitialized = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Future<void> loadLeagues() => _loadLeagues();
  CatalogueProvider() {
    initialize();
  }

  Future<void> initialize() async {
    if (_isLoading) return;
    print("inicializando el catalogo");
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Verificar conexión a internet primero

      await _checkInternetConnection();

      _client = await _createClientWithRetry();

      // Cargar datos en paralelo donde sea posible
      await Future.wait([
        _loadAllCountriesWithIsolates(),
        _loadAreasCodeWithIsolates(),
        _loadChurches(),
        _loadLeagues(),
        _getConfigurations(),
        loadBibleVersions()
      ]);

      _isInitialized = true;
      print("Catalogo inicializado");
    } catch (e) {
      print("Catalogo error");
      _errorMessage = e.toString();
      if (kDebugMode) {
        print('Error initializing CatalogueProvider: $e');
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _checkInternetConnection() async {
    // En web, InternetAddress.lookup no está soportado.
    // Usamos un método compatible con ambas plataformas.
    try {
      if (kIsWeb) {
        // En web, intentamos hacer una petición fetch a un recurso público.
        final uri = Uri.parse('https://www.google.com/favicon.ico');
        final request = await HttpClient().getUrl(uri);
        final response = await request.close();
        if (response.statusCode != 200) {
          throw Exception('No Internet connection');
        }
      } else {
        final result = await InternetAddress.lookup('google.com');
        if (result.isEmpty || result[0].rawAddress.isEmpty) {
          throw SocketException('No Internet connection');
        }
      }
    } on SocketException catch (_) {
      throw Exception('No Internet connection');
    } catch (_) {
      throw Exception('No Internet connection');
    }
  }

  Future<GraphQLClient> _createClientWithRetry({int retries = 3}) async {
    for (var i = 0; i < retries; i++) {
      try {
        final client = createClient();
        // Verificar que el cliente funciona con una consulta simple
        final options = QueryOptions(
          document: gql(r'query { __typename }'),
        );
        await client.query(options);
        return client;
      } catch (e) {
        if (i == retries - 1) rethrow;
        await Future.delayed(const Duration(seconds: 1));
      }
    }
    throw Exception('Failed to create GraphQL client after $retries attempts');
  }

  Future<void> _loadAllCountriesWithIsolates() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_countriesLoader, receivePort.sendPort);

    await for (var message in receivePort) {
      if (message is List<Country>) {
        allCountries.addAll(message);
        notifyListeners();
      } else if (message == 'completed') {
        if (kDebugMode) {
          print("countries cargados...");
        }
        break;
      }
    }
  }

  static void _countriesLoader(SendPort sendPort) async {
    final client = createClient();
    var offset = 0;
    const limit = 20;
    var hasMore = true;

    while (hasMore) {
      final options = QueryOptions(
        operationName: "GetAllCountryWithCodeAreas",
        document: gql(r'''
        query GetAllCountryWithCodeAreas($limit: Int, $offset: Int, $search: String) {
          getAllCountryWithCodeAreas(limit: $limit, offset: $offset, search: $search) {
            id
            country
            areaCodeCountry {
              id
              code
            }
          }
        }
        '''),
        variables: <String, dynamic>{
          "limit": limit,
          "offset": offset,
          "search": ""
        },
        fetchPolicy: FetchPolicy.noCache,
      );

      final result = await client.query(options);
      final data = result.data?['getAllCountryWithCodeAreas'] as List? ?? [];
      final countries = data.map((i) => Country.fromJson(i)).toList();

      sendPort.send(countries);
      offset += countries.length;
      hasMore = countries.length >= limit;
      await Future.delayed(Duration(milliseconds: 300));
    }

    sendPort.send('completed');
  }

  Future<void> _loadChurches() async {
    try {
      final options = QueryOptions(
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

      final result = await _client.query(options).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      if (result.hasException) {
        throw Exception('Failed to obtain Churches: ${result.exception}');
      }

      final data = result.data;
      if (data == null || data['getAllChurches'] == null) {
        throw Exception('No churches data received');
      }

      allChurches = (data['getAllChurches'] as List)
          .map((i) => Church.fromJson(i))
          .toList();

      notifyListeners();
    } on TimeoutException catch (e) {
      throw Exception('Request timeout: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Data format error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load leagues: ${e.toString()}');
    }
  }

  Future<void> _loadLeagues() async {
    try {
      final options = QueryOptions(
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

      final result = await _client.query(options).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      if (result.hasException) {
        throw Exception('Failed to obtain leagues: ${result.exception}');
      }

      final data = result.data;
      if (data == null || data['getAllLeagues'] == null) {
        throw Exception('No leagues data received');
      }

      allLeagues = (data['getAllLeagues'] as List)
          .map((i) => League.fromJson(removeTypename(i)))
          .toList();

      notifyListeners();
    } on TimeoutException catch (e) {
      throw Exception('Request timeout: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Data format error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load leagues: ${e.toString()}');
    }
  }

  Future<void> _getConfigurations() async {
    try {
      final options = QueryOptions(
        operationName: "GetConfigurations",
        document: gql(r'''
        query GetConfigurations {
          getConfigurations
        }
        '''),
        fetchPolicy: FetchPolicy.noCache,
      );

      final result = await _client.query(options).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      if (result.hasException) {
        throw Exception('Failed to obtain configurations: ${result.exception}');
      }

      final data = result.data;
      if (data == null || data['getConfigurations'] == null) {
        throw Exception('No configurations data received');
      }

      allConfig =
          Map<String, dynamic>.from(removeTypename(data['getConfigurations']));
          if (kDebugMode) {
            print("all configuration loaded");
          }
      notifyListeners();
    } on TimeoutException catch (e) {
      throw Exception('Request timeout: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Data format error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load leagues: ${e.toString()}');
    }
  }

  // Métodos para _loadSex()...

  Future<void> _loadAreasCodeWithIsolates() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_areasCodeLoader, receivePort.sendPort);

    await for (var message in receivePort) {
      if (message is List<AreaCode>) {
        allAreasCode.addAll(message);
        notifyListeners();
      } else if (message == 'completed') {
        if (kDebugMode) {
          print("areas code cargados...");
        }
        break;
      }
    }
  }

  static void _areasCodeLoader(SendPort sendPort) async {
    final client = createClient();
    var offset = 0;
    const limit = 20;
    var hasMore = true;

    while (hasMore) {
      final options = QueryOptions(
        operationName: "GetAllAreaCodes",
        document: gql(r'''
         query GetAllAreaCodes($limit: Int, $offset: Int, $search: String) {
            getAllAreaCodes(limit: $limit, offset: $offset, search: $search) {
              id
              code
            }
          }
        '''),
        variables: <String, dynamic>{
          "limit": limit,
          "offset": offset,
          "search": ""
        },
        fetchPolicy: FetchPolicy.noCache,
      );

      final result = await client.query(options);
      final data = result.data?['getAllAreaCodes'] as List? ?? [];
      final areas = data.map((i) => AreaCode.fromJson(i)).toList();

      sendPort.send(areas);
      offset += areas.length;
      hasMore = areas.length >= limit;
      await Future.delayed(Duration(milliseconds: 300));
    }

    sendPort.send('completed');
  }

  Future<void> loadBibleVersions() async {
    try {
      final options = QueryOptions(
        operationName: "GetAllVersion",
        document: gql(r'''
        query GetAllVersion {
            getAllVersion {
              id
              code
              version
              books {
                id
                numberBook
                modernName
              }
            }
        }
        '''),
        fetchPolicy: FetchPolicy.noCache,
      );

      final result = await _client.query(options).timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Request timed out'),
          );

      if (result.hasException) {
        throw Exception(
            'Failed to obtain get All Version: ${result.exception}');
      }

      final data = result.data;
      if (data == null || data['getAllVersion'] == null) {
        throw Exception('No get All Version data received');
      }

      allBibleVersion = (data['getAllVersion'] as List)
          .map((version) => VersionModel.fromJson(version))
          .toList();

      if (kDebugMode) {
        print('all versions loaded');
      }
      notifyListeners();
    } on TimeoutException catch (e) {
      throw Exception('Request timeout: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Data format error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to load all versions: ${e.toString()}');
    }
  }
}
