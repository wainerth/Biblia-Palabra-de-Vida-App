import 'package:biblia_palabra_de_vida_app/api_rest/rest_client.dart';
import 'package:biblia_palabra_de_vida_app/models/response_data.dart';

class CartEndpoints {
  final RestClient _restClient = RestClient.instance;

  Future<ResponseData> getCart() async {
    final response = await _restClient.get(
      '/cart',
    );
    return ResponseData.fromREST(response.data);
  }

  Future<ResponseData> addToCart(
      String bookId, String bookFormatId, int quantity) async {
    try {
      final response = await _restClient.post('/cart/add', data: {
        'bookId': bookId,
        'formatType': bookFormatId,
        'quantity': quantity,
      });
      return ResponseData.fromREST(response.data);
    } catch (error) {
      return ResponseData(
        data: null,
        error: error.toString(),
        userFriendlyError: 'Error al procesar la respuesta del servidor',
        errorType: ErrorType.parsing,
        success: false,
      );
    }
  }
}
