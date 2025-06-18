import 'package:biblia_palabra_de_vida_app/models/book_model.dart';
import 'package:biblia_palabra_de_vida_app/models/chapter_model.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class ReferenceBiblicalModel {
  final String id;
  final ChapterModel chapter;
  final BookModel book;
  final VerseModel verse;
  final int numberEndVerse;
  final int quantity;

  ReferenceBiblicalModel(
      {required this.id,
      required this.book,
      required this.chapter,
      required this.verse,
      required this.numberEndVerse,
      required this.quantity});

  factory ReferenceBiblicalModel.fromJson(Map<String, dynamic> json) {
    return ReferenceBiblicalModel(
      id: json['id'],
      book: BookModel.fromJson(json['book']),
      chapter: ChapterModel.fromJson(json['chapter']),
      verse: VerseModel.fromJson(json['verse']),
      numberEndVerse: json['numberEndVerse'],
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "book": book,
      "chapter": chapter,
      "verse": verse,
      "numberEndVerse": numberEndVerse,
      "quantity": quantity
    };
  }
}
