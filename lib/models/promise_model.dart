class PromiseModel {
  final String? id;
  final VersePromise? verse;
  final ChapterPromise? chapter;
  final BookPromise? book;
  final bool? hasViewed;
  final String? color;
  final int? energyPoint;

  PromiseModel({
    this.id,
    this.verse,
    this.chapter,
    this.book,
    this.color,
    this.energyPoint,
    this.hasViewed,
  });

  PromiseModel copyWith(
      {String? id,
      VersePromise? verse,
      ChapterPromise? chapter,
      BookPromise? book,
      bool? hasViewed,
      String? color,
      int? energyPoint}) {
    return PromiseModel(
        id: id ?? this.id,
        verse: verse ?? this.verse,
        chapter: chapter ?? this.chapter,
        book: book ?? this.book,
        color: color ?? this.color,
        hasViewed: hasViewed ?? this.hasViewed,
        energyPoint: energyPoint ?? this.energyPoint);
  }

  factory PromiseModel.fromJson(Map<String, dynamic> json) {
    return PromiseModel(
        id: json['id'],
        verse: json['verse'] != null
            ? VersePromise.fromJson(json['verse'] as Map<String, dynamic>)
            : null,
        chapter: json['chapter'] != null
            ? ChapterPromise.fromJson(json['chapter'] as Map<String, dynamic>)
            : null,
        book: json['book'] != null
            ? BookPromise.fromJson(json['book'] as Map<String, dynamic>)
            : null,
        color: json['color'] ?? '',
        hasViewed: json['hasViewed'],
        energyPoint: json['energyPoint']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'verse': verse?.toJson(),
      'chapter': chapter?.toJson(),
      'book': book?.toJson(),
      'color': color,
      'hasViewed': hasViewed,
      'energyPoint': energyPoint
    };
  }
}

class VersePromise {
  final int? verse;
  final String? text;

  VersePromise({this.verse, this.text});

  factory VersePromise.fromJson(Map<String, dynamic> json) {
    return VersePromise(
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

class ChapterPromise {
  final int? chapter;

  ChapterPromise({this.chapter});

  factory ChapterPromise.fromJson(Map<String, dynamic> json) {
    return ChapterPromise(
      chapter: json['chapter'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
    };
  }
}

class BookPromise {
  final String? modernName;

  BookPromise({this.modernName});

  factory BookPromise.fromJson(Map<String, dynamic> json) {
    return BookPromise(
      modernName: json['modernName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modernName': modernName,
    };
  }
}
