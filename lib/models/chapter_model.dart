import 'package:biblia_palabra_de_vida_app/models/models.dart';

class ChapterModel extends GridItem {
  @override
  final String? id;
  final int? bookId;
  final int chapter;
  final List<VerseModel>? verses;
  final int? status;

  ChapterModel({
    this.id,
    this.bookId,
    required this.chapter,
    this.verses,
    this.status,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    List<VerseModel> verses = [];
    if (json['verses'] != null) {
      verses = (json['verses'] as List)
          .map((verse) => VerseModel.fromJson(verse))
          .toList()
        ..sort((a, b) => a.verse.compareTo(b.verse));
    }
    return ChapterModel(
        id: json['id'] ?? '',
        bookId: json['bookId'] ?? 0,
        chapter: json['chapter'],
        verses: verses,
        status: json['status'] ?? 1);
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

  @override
  String get displayText => chapter.toString();
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
