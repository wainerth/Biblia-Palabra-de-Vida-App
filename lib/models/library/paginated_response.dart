// lib/api_rest/models/paginated_response.dart
class PaginatedResponse<T> {
  final bool success;
  final List<T> data;
  final PaginationInfo pagination;
  final FiltersInfo? filters;
  
  PaginatedResponse({
    required this.success,
    required this.data,
    required this.pagination,
    this.filters,
  });
  
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedResponse(
      success: json['success'] ?? false,
      data: (json['data'] as List)
          .map((item) => fromJsonT(item))
          .toList(),
      pagination: PaginationInfo.fromJson(json['pagination']),
      filters: json['filters'] != null 
          ? FiltersInfo.fromJson(json['filters']) 
          : null,
    );
  }
}

class PaginationInfo {
  final int total;
  final int limit;
  final int offset;
  final int totalPages;
  
  PaginationInfo({
    required this.total,
    required this.limit,
    required this.offset,
    required this.totalPages,
  });
  
  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      total: json['total'],
      limit: json['limit'],
      offset: json['offset'],
      totalPages: json['totalPages'],
    );
  }
}

class FiltersInfo {
  final String? genre;
  final String? search;
  final String? author;
  final bool? isBestseller;
  final bool? isNewRelease;
  
  FiltersInfo({
    this.genre,
    this.search,
    this.author,
    this.isBestseller,
    this.isNewRelease,
  });
  
  factory FiltersInfo.fromJson(Map<String, dynamic> json) {
    return FiltersInfo(
      genre: json['genre'],
      search: json['search'],
      author: json['author'],
      isBestseller: json['is_bestseller'],
      isNewRelease: json['is_new_release'],
    );
  }
}