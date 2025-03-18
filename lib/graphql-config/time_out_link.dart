import 'dart:async';

import 'package:graphql_flutter/graphql_flutter.dart';

class TimeoutLink extends Link {
  final Link _link;
  final Duration timeout;

  TimeoutLink(this._link, {required this.timeout});

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    try {
      yield* _link.request(request, forward).timeout(timeout);
    } on TimeoutException catch (e) {
      yield Response(errors: [
        GraphQLError(message: 'Timeout: ${e.message}')
      ], data: null, response: {});
    }
  }
}