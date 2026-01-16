// models/pagination_model.dart
class PaginationModel<T> {
  final List<T> items;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  PaginationModel({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });
}

class SearchParams {
  final String query;
  final int page;
  final int limit;

  SearchParams({
    this.query = '',
    this.page = 1,
    this.limit = 20,
  });

  SearchParams copyWith({
    String? query,
    int? page,
    int? limit,
  }) {
    return SearchParams(
      query: query ?? this.query,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }
}
