import 'package:biblia_palabra_de_vida_app/models/models.dart';

class WordSearchResult {
  final VerseModel verse;
  final ChapterModel chapter;
  final BookModel book;

  WordSearchResult({
    required this.verse,
    required this.chapter,
    required this.book,
  });

  factory WordSearchResult.fromJson(Map<String, dynamic> json) {
    return WordSearchResult(
      verse: VerseModel.fromJson(json['verse']),
      chapter: ChapterModel.fromJson(json['chapter']),
      book: BookModel.fromJson(json['book']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verse': verse.toJson(),
      'chapter': chapter.toJson(),
      'book': book.toJson(),
    };
  }
}
