import 'package:biblia_palabra_de_vida_app/models/models.dart';

class WordSearchResult {
  final VerseModelText verse;
  final ChapterModel chapter;
  final BookModel book;

  WordSearchResult({
    required this.verse,
    required this.chapter,
    required this.book,
  });

  factory WordSearchResult.fromJson(Map<String, dynamic> json) {
    return WordSearchResult(
      verse: VerseModelText.fromJson(json['verse']),
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

class Occurrence {
  final int start;
  final int end;

  Occurrence({required this.start, required this.end});

  factory Occurrence.fromJson(Map<String, dynamic> json) {
    return Occurrence(start: json['start'], end: json['end']);
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }
}

class VerseModelText {
  final String id;
  final int chapterId;
  final int verse;
  final String text;
  final List<Occurrence> occurrence;

  VerseModelText({
    required this.id,
    required this.chapterId,
    required this.verse,
    required this.text,
    required this.occurrence,
  });

  factory VerseModelText.fromJson(Map<String, dynamic> json) {
    List<Occurrence> listOccurrence = [];
    if (json['occurrence'] != null) {
      listOccurrence.add(Occurrence.fromJson(json['occurrence']));
    }
    return VerseModelText(
      id: json['id'],
      chapterId: json['chapterId'] ?? 0,
      verse: json['verse'] ?? 0,
      text: json['text'] ?? '',
      occurrence: listOccurrence,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'verse': verse,
      'text': text,
      'occurrence': occurrence
    };
  }
}
