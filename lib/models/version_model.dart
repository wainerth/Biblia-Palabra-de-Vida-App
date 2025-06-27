import 'package:biblia_palabra_de_vida_app/models/models.dart';

class VersionModel {
  final String id;
  final String version;
  final List<BookModel> books;

  VersionModel({required this.id, required this.version, required this.books});

  factory VersionModel.fromJson(Map<String, dynamic> json) {
    final books = (json['books'] as List)
        .map((book) => BookModel.fromJson(book))
        .toList()
      ..sort((a, b) => a.numberBook.compareTo(b.numberBook));
    return VersionModel(
      id: json['id'],
      version: json['version'] ?? '',
      books: books,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'version': version, 'books': books};
  }
}
