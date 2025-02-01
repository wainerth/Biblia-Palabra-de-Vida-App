import 'package:graphql_flutter/graphql_flutter.dart';

class ResponseData {
  final dynamic data;
  final String? error;

  ResponseData({required this.data, this.error});

  factory ResponseData.fromQueryResult(QueryResult result) {
    String? errorMessage;
    if (result.exception != null &&
        result.exception!.graphqlErrors.isNotEmpty) {
      errorMessage = result.exception!.graphqlErrors.first.message;
    }
    return ResponseData(
      data: _removeTypename(result.data),
      error: errorMessage,
    );
  }
}

_removeTypename(values){

  if (values is Map<String, dynamic>) {
    values.removeWhere((key, value) => key == '__typename');
    values.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        _removeTypename(value);
      } else if (value is List) {
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            _removeTypename(item);
          }
        }
      }
    });
  }
  return values;
}