import 'package:biblia_palabra_de_vida_app/models/models.dart';

class ResponseReferenceBiblicalModel {
  final String bibleName;
  final String bookName;
  final String chapterNumber;
  final List<Verse> verses;

  ResponseReferenceBiblicalModel(
      {required this.bibleName,
      required this.bookName,
      required this.chapterNumber,
      required this.verses});

  factory ResponseReferenceBiblicalModel.fromJson(Map<String, dynamic> json) {
    return ResponseReferenceBiblicalModel(
      bibleName: json['bibleName'],
      bookName: json['bookName'],
      chapterNumber: json['chapterNumber'],
      verses: json['verses'] != null && json['verses'].isNotEmpty
          ? json['verses'].map<Verse>((verse) => Verse.fromJson(verse)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bibleName": bibleName,
      "bookName": bookName,
      "chapterNumber": chapterNumber,
      "verses": verses
    };
  }
}
