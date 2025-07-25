import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_config.dart';

GraphQLClient createClient({String? authToken}) {
  final HttpLink httpLink = HttpLink(
    "${GraphQLConfig.baseUrl}/graphql",
    defaultHeaders: {
      'Content-Type': 'application/json', // Fuerza JSON
      'apollo-require-preflight': 'true', // Indica que es una solicitud segura
    },
  );

  final AuthLink authLink = AuthLink(
    getToken: () async => authToken ?? GraphQLConfig.authToken,
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
