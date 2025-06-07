import 'package:biblia_palabra_de_vida_app/models/models.dart';

class ChapterModel {
  final String id;
  final int bookId;
  final int chapter;
  final List<VerseModel> verses;
  final int status;

  ChapterModel({
    required this.id,
    required this.bookId,
    required this.chapter,
    required this.verses,
    required this.status,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
        id: json['id'],
        bookId: json['bookId'] ?? 0,
        chapter: json['chapter'],
        verses: json['verses'] != null
            ? (json['verses'] as List)
                .map((book) => VerseModel.fromJson(book))
                .toList()
            : [],
        status: json['status']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'chapter': chapter,
      'verses': verses,
      'status': status
    };
  }
}
