import 'package:biblia_palabra_de_vida_app/models/models.dart';

class InputDataSearchModel {
  final String versionId;
  final VersionModel? version;
  final String bookId;
  final BookModel? book;
  final String chapterId;
  final ChapterModel? chapter;
  final String startVerseId;
  final String endVerseId;
  final List<VerseModel>? verses;

  InputDataSearchModel({
    this.version,
    this.book,
    this.chapter,
    required this.versionId,
    required this.bookId,
    required this.chapterId,
    required this.startVerseId,
    required this.endVerseId,
    this.verses,
  });

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
