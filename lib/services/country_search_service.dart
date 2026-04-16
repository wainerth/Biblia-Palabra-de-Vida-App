// services/country_search_service.dart
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/foundation.dart';

class CountrySearchService {
  CountrySearchService();

  Future<PaginationModel<ModelData>> searchCountries({
    String query = '',
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final result = await getCountries(query: query, page: page, limit: limit);

      if (result.error != null) {
        throw Exception('Error GraphQL: ${result.error}');
      }

      final data = result.data as List? ?? [];

      // Convertir de Country a ModelData
      final countries = data.map((json) {
        final country = Country.fromJson(json);
        return ModelData(
          value: country.id,
          label: country.name,
          originalData: country,
        );
      }).toList();

      // Calcular si hay más páginas
      final hasMore = countries.length >= limit;

      return PaginationModel(
        items: countries,
        currentPage: page,
        totalPages:
            hasMore ? page + 1 : page, // Simplificado - ajusta según tu API
        hasMore: hasMore,
      );
    } catch (e) {
      throw Exception('Error buscando países: $e');
    }
  }

  // Método específico para obtener el país seleccionado si ya está en cache
  Future<ModelData?> getCountryById(String countryId) async {
    final GraphQLClient client = createClient();

    try {
      final options = QueryOptions(
        operationName: "GetCountryById",
        document: gql(r'''
          query GetCountryById($countryId: String!) {
            getCountryById(countryId: $countryId) {
              name
              id
              areaCodeCountry {
                code
                id
              }
              isoCode
            }
          }
        '''),
        variables: {'countryId': countryId},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await client.query(options);
      if (result.hasException || result.data == null) return null;

      final json = result.data?['getCountryById'];
      if (json == null) return null;

      final country = Country.fromJson(json);
      return ModelData(
        value: country.id,
        label: country.name,
        originalData: country,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error obteniendo país: $e');
      }
      return null;
    }
  }
}

class AreaCodeSearchService {
  AreaCodeSearchService();

  Future<PaginationModel<ModelData>> searchAreaCodes({
    String query = '',
    int page = 1,
    int limit = 20,
  }) async {
    final GraphQLClient client = createClient();

    try {
      final offset = (page - 1) * limit;

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

      if (result.hasException) {
        throw Exception('Error GraphQL: ${result.exception}');
      }

      final data = result.data?['getAllAreasCode'] as List? ?? [];

      final areaCodes = data.map((json) {
        final areaCode = AreaCode.fromJson(json);
        return ModelData(
          value: areaCode.id,
          label: areaCode.code,
          originalData: areaCode,
        );
      }).toList();

      final hasMore = areaCodes.length >= limit;

      return PaginationModel(
        items: areaCodes,
        currentPage: page,
        totalPages: hasMore ? page + 1 : page,
        hasMore: hasMore,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error buscando códigos de área: $e');
      }
      throw Exception('Error buscando códigos de área: $e');
    }
  }

  // Método específico para obtener el país seleccionado si ya está en cache
  Future<AreaCode?> getCodeAreaById(String codeAreaId) async {
    final GraphQLClient client = createClient();

    try {
      final options = QueryOptions(
        operationName: "GetCodeAreaById",
        document: gql(r'''
          query GetCodeAreaById($codeAreaId: String!) {
            getCodeAreaById(codeAreaId: $codeAreaId) {
              id
              code
            }
          }
        '''),
        variables: <String, dynamic>{'codeAreaId': codeAreaId},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await client.query(options);
      if (result.hasException || result.data == null) return null;

      final json = result.data?['getCodeAreaById'];
      if (json == null) return null;

      final codeArea = AreaCode.fromJson(json);
      return codeArea;
    } catch (e) {
      if (kDebugMode) {
        print('Error obteniendo Código de area: $e');
      }
      return null;
    }
  }

  // Método específico para obtener el país seleccionado si ya está en cache
  Future<AreaCode?> getCodeAreaByCode(String code) async {
    final GraphQLClient client = createClient();

    try {
      final options = QueryOptions(
        operationName: "GetCodeAreaByCode",
        document: gql(r'''
          query GetCodeAreaByCode($codeArea: String!) {
            getCodeAreaByCode(codeArea: $codeArea) {
              id
              code
            }
          }
        '''),
        variables: <String, dynamic>{'codeArea': code},
        fetchPolicy: FetchPolicy.networkOnly,
      );

      final result = await client.query(options);
      if (result.hasException || result.data == null) return null;

      final json = result.data?['getCodeAreaByCode'];
      if (json == null) return null;

      final codeArea = AreaCode.fromJson(json);
      return codeArea;
    } catch (e) {
      if (kDebugMode) {
        print('Error obteniendo Código de area: $e');
      }
      return null;
    }
  }
}
