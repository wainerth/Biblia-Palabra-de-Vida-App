class BookModel {
  final String id;
  final int numberBook;
  final String modernName;
  final int chapters;

  BookModel(
      {required this.id,
      required this.numberBook,
      required this.modernName,
      required this.chapters});
  BookModel copyWith({
    String? id,
    int? numberBook,
    String? modernName,
    int? chapters,
  }) {
    return BookModel(
      id: id ?? this.id,
      numberBook: numberBook ?? this.numberBook,
      modernName: modernName ?? this.modernName,
      chapters: chapters ?? this.chapters,
    );
  }

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      numberBook: json['numberBook'] ?? 0,
      modernName: json['modernName'] ?? '',
      chapters: json['chapters'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numberBook': numberBook,
      'moderName': modernName,
      'chapters': chapters
    };
  }
}
