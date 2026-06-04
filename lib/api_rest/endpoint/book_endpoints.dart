import 'package:biblia_palabra_de_vida_app/api_rest/rest_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';

class BookEndpoints {
  final RestClient _restClient = RestClient.instance;

  Future<ResponseData> getBooks({
    int page = 1,
    int pageSize = 20,
    String? genre,
    String? search,
    String? author,
    bool? is_bestseller,
    bool? is_new_release,
    String? searchQuery,
  }) async {
    final queryParams = {
      'limit': pageSize.toString(),
      'offset': '0',
      'genre': genre,
      'search': search,
      'author': author,
      'is_bestseller': is_bestseller,
      'is_new_release': is_new_release,
      if (searchQuery != null && searchQuery.isNotEmpty) 'search': searchQuery,
    };

    final response = await _restClient.get('/books', queryParams: queryParams);
    return ResponseData.fromREST(response.data);
  }

  Future<ResponseData> getBookById(int bookId) async {
    final response = await _restClient.get('/books/$bookId');
    return ResponseData.fromREST(response.data);
  }
}
