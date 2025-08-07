import 'package:biblia_palabra_de_vida_app/models/models.dart';

class CopyModelVerse {
  final Book book;
  final ChapterModel chapter;
  final VerseModel verse;

  CopyModelVerse({
    required this.book,
    required this.chapter,
    required this.verse,
  });

  factory CopyModelVerse.fromJson(Map<String, dynamic> json) {
    return CopyModelVerse(
      book: Book.fromJson(json['book']),
      chapter: ChapterModel.fromJson(json['chapter']),
      verse: VerseModel.fromJson(json['verse']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book': book,
      'chapter': chapter,
      'verse': verse,
    };
  }
}
