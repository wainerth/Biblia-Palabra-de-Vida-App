import 'package:biblia_palabra_de_vida_app/models/models.dart';

class VerseModel extends GridItem {
  final String? id;
  final int? chapterId;
  final int verse;
  final String text;
  final String? colorHighlight;
  final List<HighlightRangeModel?>? highlights;
  final int? posIni;
  final int? posFin;
  final int? status;

  VerseModel({
    this.id,
    this.chapterId,
    required this.verse,
    required this.text,
    this.colorHighlight,
    this.posIni,
    this.posFin,
    this.highlights,
    this.status,
  });
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerseModel &&
          runtimeType == other.runtimeType &&
          id == other.id; // Usa un identificador único

  @override
  int get hashCode => id.hashCode;
  VerseModel copyWith({
    int? posIni,
    int? posFin,
    String? text,
    int? verse,
  }) {
    return VerseModel(
        id: id,
        chapterId: chapterId,
        verse: verse ?? this.verse,
        text: text ?? this.text,
        posIni: posIni,
        posFin: posFin,
        colorHighlight: colorHighlight,
        highlights: highlights,
        status: status);
  }

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    return VerseModel(
      id: json['id'] ?? '',
      chapterId: json['chapterId'] ?? 0,
      verse: json['verse'] ?? 0,
      text: json['text'] ?? '',
      posIni: json['posIni'] ?? 0,
      posFin: json['PosFin'] ?? 0,
      colorHighlight: json['colorHighlight'] ?? '',
      highlights: (json['highlights'] as List<dynamic>? ?? [])
          .map((e) => e == null ? null : HighlightRangeModel.fromJson(e))
          .toList(),
      status: json['status'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chapterId': chapterId,
      'verse': verse,
      'text': text,
      'posIni': posIni,
      'posFin': posFin,
      'colorHighlight': colorHighlight,
      'status': status
    };
  }

  @override
  String get displayText => verse.toString();
}
