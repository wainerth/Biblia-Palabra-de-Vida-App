import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CatalogueProvider extends ChangeNotifier {
  late GraphQLClient _client;
  late List<Country> allCountries;
  late List<Church> allChurches;
  late List<League> allLeagues;
  late List<CourseModel> allCourses;
  
  CatalogueProvider() {
    init();
  }
  Future<void> init() async {
    await _loadCountries();
    await _loadSex();
    await _loadVersions();
    await _loadChurches();
    await _loadLeagues();
  }

  Future<void> _loadCountries() async {
    // Lógica para cargar la lista de países
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    _client = createClient(authToken: userToken);

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
        throw Exception('Failed to obtain Countries');
      }

      final data = result.data;
      if (data == null || data['getAllCountries'] == null) {
        throw Exception('Failed to obtain Countries');
      }

      allCountries = (data['getAllCountries'] as List)
          .map((i) => Country.fromJson(i))
          .toList();

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to obtain Countries $e');
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
    
 final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    _client = createClient(authToken: userToken);

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
        throw Exception('Failed to obtain Churches');
      }

      final data = result.data;
      if (data == null || data['getAllChurches'] == null) {
        throw Exception('Failed to obtain Churches');
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
    
 final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    _client = createClient(authToken: userToken);

    QueryOptions options = QueryOptions(
      operationName: "GetAllLeagues",
      document: gql(r'''
     query GetAllLeagues {
          getAllLeagues {
            id
            name
            minMembers
            maxMembers
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
        throw Exception('Failed to obtain leagues');
      }

      final data = result.data;
      if (data == null || data['getAllLeagues'] == null) {
        throw Exception('Failed to obtain leagues');
      }

      allLeagues = (data['getAllLeagues'] as List)
          .map((i) => 
          League.fromJson(removeTypename(i)))
          .toList();

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to obtain leagues $e');
    }
  }
  
}
