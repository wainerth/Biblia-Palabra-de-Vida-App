import 'package:biblia_palabra_de_vida_app/models/img.dart';

class DailyWord {
  final Book? book;
  final Chapter? chapter;
  final Verse? verse;
  final Img? img;

  DailyWord({
    this.book,
    this.chapter,
    this.verse,
    this.img,
  });

  factory DailyWord.fromJson(Map<String, dynamic> json) {
    return DailyWord(
      book: json['book'] != null ? Book.fromJson(json['book'] as Map<String, dynamic>) : null,
      chapter: json['chapter'] != null ? Chapter.fromJson(json['chapter'] as Map<String, dynamic>) : null,
      verse: json['verse'] != null ? Verse.fromJson(json['verse'] as Map<String, dynamic>) : null,
      img: json['img'] != null ? Img.fromJson(json['img'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book': book?.toJson(),
      'chapter': chapter?.toJson(),
      'verse': verse?.toJson(),
      'img': img?.toJson(),
    };
  }
}

class Book {
  final String? modernName;

  Book({this.modernName});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      modernName: json['modernName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modernName': modernName,
    };
  }
}

class Chapter {
  final int? chapter;

  Chapter({this.chapter});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      chapter: json['chapter'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
    };
  }
}

class Verse {
  final int? verse;
  final String? text;

  Verse({this.verse, this.text});

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      verse: json['verse'] as int?,
      text: json['text'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verse': verse,
      'text': text,
    };
  }
}
