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
      book: json['book'] != null
          ? Book.fromJson(json['book'] as Map<String, dynamic>)
          : null,
      chapter: json['chapter'] != null
          ? Chapter.fromJson(json['chapter'] as Map<String, dynamic>)
          : null,
      verse: json['verse'] != null
          ? Verse.fromJson(json['verse'] as Map<String, dynamic>)
          : null,
      img: json['img'] != null
          ? Img.fromJson(json['img'] as Map<String, dynamic>)
          : null,
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
  final String? id;
  final String? modernName;
  final String? bibleId;

  Book({this.id, this.modernName, this.bibleId});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      modernName: json['modernName'] as String?,
      bibleId: json['bibleId'] != null ?  json['bibleId'].toString() : ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modernName': modernName,
      'bibleId': bibleId
    };
  }
}

class Chapter {
  final String? id;
  final int? chapter;

  Chapter({this.id, this.chapter});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'] ?? '',
      chapter: json['chapter'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapter': chapter,
    };
  }
}

class Verse {
  final String? id;
  final int? verse;
  final String? text;

  Verse({this.id, this.verse, this.text});

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'] ?? '',
      verse: json['verse'] as int?,
      text: json['text'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'verse': verse,
      'text': text,
    };
  }
}
