import 'package:biblia_palabra_de_vida_app/models/models.dart';

class FavoriteVerse {
  final String userId;
  final BookModel book;
  final ChapterModel chapter;
  final VerseModel verse;

  FavoriteVerse({
    required this.userId,
    required this.book,
    required this.chapter,
    required this.verse,
  });

// Método copyWith
  FavoriteVerse copyWith({
    String? userId,
    BookModel? book,
    ChapterModel? chapter,
    VerseModel? verse,
  }) {
    return FavoriteVerse(
      userId: userId ?? this.userId,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
    );
  }

  factory FavoriteVerse.fromJson(Map<String, dynamic> json) {
    return FavoriteVerse(
      userId: json['userId'] as String,
      book: BookModel.fromJson(json['book'] as Map<String, dynamic>),
      chapter: ChapterModel.fromJson(json['chapter'] as Map<String, dynamic>),
      verse: VerseModel.fromJson(json['verse'] as Map<String, dynamic>),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'book': book.toJson(),
      'chapter': chapter.toJson(),
      'verse': verse.toJson(),
    };
  }
}
