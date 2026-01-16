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
  Map<String, bool> _serviceStatus = {};

  bool get isSocketInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isPartiallyInitialized => 
      _serviceStatus['Countries'] == true || 
      _serviceStatus['AreaCodes'] == true;
  bool get hasCriticalData => 
      _serviceStatus['Countries'] == true && 
      _serviceStatus['AreaCodes'] == true;
  
  bool isServiceLoaded(String serviceName) => _serviceStatus[serviceName] == true;
  List<String> get failedServices => _serviceStatus.entries
      .where((e) => e.value == false)
      .map((e) => e.key)
      .toList();

  Future<void> loadLeagues() => _loadLeagues();
  
  CatalogueProvider() {
    initialize();
  }

  Future<void> initialize() async {
    if (_isLoading) return;
    if (_isInitialized) return;

    if (kDebugMode) {
      print("inicializando el catalogo");
    }
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Verificar conexión a internet primero
      await _checkInternetConnection();

      _client = await _createClientWithRetry();

      // Cargar datos con manejo robusto de errores
      await _loadAllDataWithErrorHandling();

      _isInitialized = true;
      if (kDebugMode) {
        print("Catalogo inicializado exitosamente");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error en inicializar del catalogo: $e");
      }
      _errorMessage = "Algunos servicios no pudieron cargarse. Puedes intentarlo más tarde.";
      // No rethrow - permitimos que el provider se inicialice parcialmente
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadAllDataWithErrorHandling() async {
    _serviceStatus = {}; // Map para tracker estado de cada servicio

    // Cargar servicios críticos primero (países y códigos de área)
    // await _loadWithRetry('Countries', _loadAllCountriesWithIsolates, retries: 3);
    // await _loadWithRetry('AreaCodes', _loadAreasCodeWithIsolates, retries: 3);

    // Cargar servicios no críticos en paralelo
    await Future.wait([
      _loadWithRetry('Churches', _loadChurches, retries: 2),
      _loadWithRetry('Leagues', _loadLeagues, retries: 2),
      _loadWithRetry('Configurations', _getConfigurations, retries: 2),
      _loadWithRetry('BibleVersions', loadBibleVersions, retries: 2),
    ], eagerError: false);

    // Verificar si tenemos al menos los servicios críticos
    _checkCriticalServices();
    _logLoadStatus();
  }

  Future<void> _loadWithRetry(
    String serviceName, 
    Future<void> Function() loadFunction, 
    {int retries = 3}
  ) async {
    for (int attempt = 1; attempt <= retries; attempt++) {
      try {
        await loadFunction();
        _serviceStatus[serviceName] = true;
        if (kDebugMode) {
          print('✅ $serviceName loaded successfully (attempt $attempt)');
        }
        return;
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Attempt $attempt failed for $serviceName: $e');
        }
        
        if (attempt == retries) {
          _serviceStatus[serviceName] = false;
          if (kDebugMode) {
            print('❌ Failed to load $serviceName after $retries attempts');
          }
        } else {
          // Backoff progresivo: 1s, 2s, 3s...
          await Future.delayed(Duration(seconds: attempt));
        }
      }
    }
  }

  void _checkCriticalServices() {
    final criticalServices = ['Countries', 'AreaCodes'];
    final criticalFailed = criticalServices.any((service) => _serviceStatus[service] != true);
    
    if (criticalFailed) {
      if (kDebugMode) {
        print('🚨 Critical services failed - provider partially initialized');
      }
    }
  }

  void _logLoadStatus() {
    final successful = _serviceStatus.entries.where((e) => e.value == true).length;
    final failed = _serviceStatus.entries.where((e) => e.value == false).length;
    
    if (kDebugMode) {
      print('📊 Catalogue Load Summary:');
      print('   ✅ $successful services loaded successfully');
      print('   ❌ $failed services failed');
      
      _serviceStatus.forEach((service, status) {
        if (kDebugMode) {
          print('   ${status == true ? '✅' : '❌'} $service');
        }
      });
    }
  }

  Future<void> retryFailedServices() async {
    final failedServices = _serviceStatus.entries
        .where((e) => e.value == false)
        .map((e) => e.key)
        .toList();
    
    if (failedServices.isEmpty) {
      if (kDebugMode) {
        print('🎉 All services are already loaded');
      }
      return;
    }
    
    if (kDebugMode) {
      print('🔄 Retrying failed services: $failedServices');
    }
    
    _isLoading = true;
    notifyListeners();
    
    try {
      for (final service in failedServices) {
        await _retryService(service);
      }
      
      if (kDebugMode) {
        print('✅ All services retried successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Some services still failed after retry: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _retryService(String serviceName) async {
    switch (serviceName) {
      case 'Countries':
        await _loadAllCountriesWithIsolates();
        break;
      case 'AreaCodes':
        await _loadAreasCodeWithIsolates();
        break;
      case 'Churches':
        await _loadChurches();
        break;
      case 'Leagues':
        await _loadLeagues();
        break;
      case 'Configurations':
        await _getConfigurations();
        break;
      case 'BibleVersions':
        await loadBibleVersions();
        break;
    }
    _serviceStatus[serviceName] = true;
  }

  Future<void> _checkInternetConnection() async {
    try {
      if (kIsWeb) {
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
        if (kDebugMode && allCountries.isNotEmpty) {
          if (kDebugMode) {
            print("countries cargados...");
          }
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
            name
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
          data{
            id
            name
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
        throw Exception('Failed to obtain Churches: ${result.exception}');
      }

      final data = result.data;
      if (data == null ||
          data['getAllChurches'] == null ||
          data['getAllChurches']['data'] == null) {
        throw Exception('No churches data received');
      }

      allChurches = (data['getAllChurches']["data"] as List)
          .map((i) => Church.fromJson(i))
          .toList();
      if (kDebugMode && allChurches.isNotEmpty) {
        if (kDebugMode) {
          print("all Churches loaded...");
        }
      }
      notifyListeners();
    } on TimeoutException catch (e) {
      throw Exception('Request timeout: ${e.message}');
    } on FormatException catch (e) {
      throw Exception('Data format error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get all Churches: ${e.toString()}');
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
      throw Exception('Failed to load configurations: ${e.toString()}');
    }
  }

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