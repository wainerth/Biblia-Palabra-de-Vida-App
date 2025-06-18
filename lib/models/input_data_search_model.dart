class InputDataSearchModel {
  final String versionId;
  final String bookId;
  final String chapterId;
  final String startVerseId;
  final String endVerseId;

  InputDataSearchModel(
      {required this.versionId,
      required this.bookId,
      required this.chapterId,
      required this.startVerseId,
      required this.endVerseId});

  factory InputDataSearchModel.fromJson(Map<String, dynamic> json) {
    return InputDataSearchModel(
      versionId: json['versionId'],
      bookId: json['bookId'],
      chapterId: json['chapterId'],
      startVerseId: json['startVerseId'],
      endVerseId: json['endVerseId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "versionId": versionId,
      "bookId": bookId,
      "chapterId": chapterId,
      "startVerseId": startVerseId,
      "endVerseId": endVerseId,
    };
  }
}
