import 'package:biblia_palabra_de_vida_app/models/library/book_format_model.dart';

class BookModel {
  final int id;
  final String? isbn;
  final String title;
  final String? subtitle;
  final String slug;
  final String? description;
  final String author;
  final String? publisher;
  final DateTime? publishedDate;
  final String? language;
  final int? pages;
  final String? genre;
  final bool isBestseller;
  final bool isNewRelease;
  final String? coverImageUrl;
  final String? coverImageFile;
  final String? metaTitle;
  final String? metaDescription;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  // Relaciones
  final List<BookFormat>? formats;
  final List<ReviewModel>? reviews;
  // Campos calculados
  double? get minPrice {
    if (formats == null || formats!.isEmpty) return null;
    return formats!.map((f) => f.price).reduce((a, b) => a < b ? a : b);
  }

  double? get maxPrice {
    if (formats == null || formats!.isEmpty) return null;
    return formats!.map((f) => f.price).reduce((a, b) => a > b ? a : b);
  }

  String get priceRange {
    if (minPrice == null) return 'Precio no disponible';
    if (maxPrice == minPrice) {
      return '\$${minPrice!.toStringAsFixed(2)}';
    }
    return '\$${minPrice!.toStringAsFixed(2)} - \$${maxPrice!.toStringAsFixed(2)}';
  }

  BookModel(
      {required this.id,
      this.isbn,
      required this.title,
      this.subtitle,
      required this.slug,
      this.description,
      required this.author,
      this.publisher,
      this.publishedDate,
      this.language,
      this.pages,
      this.genre,
      required this.isBestseller,
      required this.isNewRelease,
      this.coverImageUrl,
      this.coverImageFile,
      this.metaTitle,
      this.metaDescription,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.formats,
      this.reviews});

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      isbn: json['isbn'],
      title: json['title'],
      subtitle: json['subtitle'],
      slug: json['slug'],
      description: json['description'],
      author: json['author'],
      publisher: json['publisher'],
      publishedDate: json['published_date'] != null
          ? DateTime.tryParse(json['published_date'])
          : null,
      language: json['language'],
      pages: json['pages'],
      genre: json['genre'],
      reviews: json['reviews'] != null && json['reviews'] is List
          ? (json['reviews'] as List)
              .map((r) => ReviewModel.fromJson(r))
              .toList()
          : null,
      isBestseller: json['is_bestseller'] ?? false,
      isNewRelease: json['is_new_release'] ?? false,
      coverImageUrl: json['cover_image_url'],
      coverImageFile: json['cover_image_file'],
      metaTitle: json['meta_title'],
      metaDescription: json['meta_description'],
      status: json['status'] ?? 'active',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      formats: json['formats'] != null
          ? (json['formats'] as List)
              .map((f) => BookFormat.fromJson(f))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isbn': isbn,
      'title': title,
      'subtitle': subtitle,
      'slug': slug,
      'description': description,
      'author': author,
      'publisher': publisher,
      'published_date': publishedDate?.toIso8601String().split('T').first,
      'language': language,
      'pages': pages,
      'genre': genre,
      'is_bestseller': isBestseller,
      'is_new_release': isNewRelease,
      'cover_image_url': coverImageUrl,
      'cover_image_file': coverImageFile,
      'meta_title': metaTitle,
      'meta_description': metaDescription,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'formats': formats?.map((f) => f.toJson()).toList(),
    };
  }

  // Copiar con modificaciones
  BookModel copyWith({
    int? id,
    String? isbn,
    String? title,
    String? subtitle,
    String? slug,
    String? description,
    String? author,
    String? publisher,
    DateTime? publishedDate,
    String? language,
    int? pages,
    String? genre,
    bool? isBestseller,
    bool? isNewRelease,
    String? coverImageUrl,
    String? coverImageFile,
    String? metaTitle,
    String? metaDescription,
    String? status,
    String? createdAt,
    String? updatedAt,
    List<BookFormat>? formats,
  }) {
    return BookModel(
      id: id ?? this.id,
      isbn: isbn ?? this.isbn,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      author: author ?? this.author,
      publisher: publisher ?? this.publisher,
      publishedDate: publishedDate ?? this.publishedDate,
      language: language ?? this.language,
      pages: pages ?? this.pages,
      genre: genre ?? this.genre,
      isBestseller: isBestseller ?? this.isBestseller,
      isNewRelease: isNewRelease ?? this.isNewRelease,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      coverImageFile: coverImageFile ?? this.coverImageFile,
      metaTitle: metaTitle ?? this.metaTitle,
      metaDescription: metaDescription ?? this.metaDescription,
      status: status ?? this.status,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      formats: formats ?? this.formats,
    );
  }
}

class ReviewModel {
  final int id;
  final int bookId;
  final String? user_id;
  final String? reviewerName;
  final String? reviewerEmail;
  final String? comment;
  final int rating; // 1 a 5
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReviewModel({
    required this.id,
    required this.bookId,
    required this.user_id,
    this.reviewerName,
    this.reviewerEmail,
    this.comment,
    required this.rating,
    this.createdAt,
    this.updatedAt,
  });

  ReviewModel copyWith({
    int? id,
    int? bookId,
    String? user_id,
    String? reviewerName,
    String? reviewerEmail,
    String? comment,
    int? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      user_id: user_id ?? this.user_id,
      reviewerName: reviewerName ?? this.reviewerName,
      reviewerEmail: reviewerEmail ?? this.reviewerEmail,
      comment: comment ?? this.comment,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  ReviewModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bookId = json['book_id'],
        user_id = json['user_id'],
        reviewerName = json['reviewer_name'] ?? "Anónimo",
        reviewerEmail = json['reviewer_email'],
        comment = json['comment'],
        rating = json['rating'],
        createdAt = DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
        updatedAt = DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String());
}
