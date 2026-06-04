import 'package:biblia_palabra_de_vida_app/config/api_config.dart';
import 'package:biblia_palabra_de_vida_app/config/graphql_config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient createClient({String? authToken}) {
  final HttpLink httpLink = HttpLink(
    GraphQLConfig.endpoint,
    defaultHeaders: {
      'Content-Type': 'application/json', // Fuerza JSON
      'apollo-require-preflight': 'true', // Indica que es una solicitud segura
      
    },
  );

  final AuthLink authLink = AuthLink(
    getToken: () async => authToken ?? ApiConfig.authToken,
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

