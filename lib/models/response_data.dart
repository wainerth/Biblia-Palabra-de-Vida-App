import 'package:graphql_flutter/graphql_flutter.dart';

class ResponseData {
  final dynamic data;
  final String? error;

  ResponseData({required this.data, this.error});

  factory ResponseData.fromQueryResult(QueryResult result) {
    String? errorMessage;
    if (result.exception?.linkException != null) {
       errorMessage = result.exception!.linkException.toString();
      // Aquí puedes manejar el error de enlace, mostrar un mensaje al usuario, etc.
    } else if (result.exception!.graphqlErrors.isNotEmpty) {
      errorMessage = result.exception!.graphqlErrors.first.message;
      // Aquí puedes manejar los errores devueltos por el servidor GraphQL.
    } else {
      errorMessage = result.exception.toString();
    }
    // if (result.exception != null) {
    //   if (result.exception!.graphqlErrors.isNotEmpty) {
    //     errorMessage = result.exception!.graphqlErrors.first.message;
    //   } else if (result.exception!.linkException != null) {
    //     errorMessage = result.exception!.linkException.toString();
    //   }
    // }
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