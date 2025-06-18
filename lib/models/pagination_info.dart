class PaginationInfo {
  final int currentPage;
  final int totalPages;
  final int itemsPerPage;
  final int totalItems;
  final bool hasPreviousPage;
  final bool hasNextPage;

  PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.itemsPerPage,
    required this.totalItems,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  // Factory method to create a PaginationInfo object from a JSON map
  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      itemsPerPage: json['itemsPerPage'] as int,
      totalItems: json['totalItems'] as int,
      hasPreviousPage: json['hasPreviousPage'] as bool,
      hasNextPage: json['hasNextPage'] as bool,
    );
  }

  // Method to convert a Pagination object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'itemsPerPage': itemsPerPage,
      'totalItems': totalItems,
      'hasPreviousPage': hasPreviousPage,
      'hasNextPage': hasNextPage,
    };
  }
}