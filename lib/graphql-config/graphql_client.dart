// import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:http/io_client.dart';
// import 'dart:io';
import 'graphql_config.dart';
// import 'package:http/http.dart' as http;

GraphQLClient createClient({String? authToken}) {
    // http.Client httpClient;
  final HttpLink httpLink = HttpLink(
    GraphQLConfig.baseUrl,
    // httpClient: kIsWeb ? httpClient = http.Client() : IOClient(
    //   HttpClient()
    //     ..badCertificateCallback =
    //         (X509Certificate cert, String host, int port) => true,
    // ),
  );

  final AuthLink authLink = AuthLink(
    getToken: () async =>  authToken ?? GraphQLConfig.authToken,
  );

  final Link link = authLink.concat(httpLink);

  return GraphQLClient(
    cache: GraphQLCache(store: InMemoryStore()),
    link: link,
    defaultPolicies: DefaultPolicies(
      query: Policies(
        fetch: FetchPolicy.noCache,
        error: ErrorPolicy.all,
      ),
      mutate: Policies(
        fetch: FetchPolicy.noCache,
        error: ErrorPolicy.all,
      ),
    ),
  );
}
