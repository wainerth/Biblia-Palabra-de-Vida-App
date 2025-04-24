import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_config.dart';

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
// TimeoutLink(httpLink, timeout: Duration(seconds: 10)); /
  final Link link = authLink.concat(httpLink); //TimeoutLink(authLink.concat(httpLink),timeout: Duration(seconds: 20));

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
